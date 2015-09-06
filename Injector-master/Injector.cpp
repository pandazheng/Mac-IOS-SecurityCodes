#include <iostream>
#include <stdio.h>
#include <mach-o/loader.h>
#include <vector>
#include <assert.h>
#include <memory>

#ifndef interface 
#define interface struct
#endif

interface IMachOParser {
	virtual int Save(const char* pFileName) = 0;
	virtual bool IsMachOEncrypted() = 0;
	virtual int InjectDyLib(const char* pDynLibPath) = 0;
};

template< typename T >
class MachOParser : public IMachOParser
{
protected:
	typedef uint32_t RVA32;

	T*							 m_pMachO;
	size_t						 m_sizeFile;
	load_command*				 m_pCmdFirst;
	dylib_command*				 m_pCmdLastLoadLib;
	RVA32						 m_uiFirstSectionRVA;
	std::vector< load_command* > m_vecCommands;

	bool IsThereEnoughSpaceForCmd(const load_command* pCmd);
	int ReloadCommands();

	int Attach(uint8_t* pBuf, size_t size);

	MachOParser();// Prevent direct instantiation

public:
	~MachOParser();

	static int CreateInstance(uint8_t* pBuf, size_t size, MachOParser* &pParser);

	// IMachOParser implementation
	int Save(const char* pFileName);
	bool IsMachOEncrypted();
	int InjectDyLib(const char* pDynLibPath);
};

class MachOParserFactory
{
public:
	typedef std::shared_ptr< IMachOParser > ParserPtr_t;
	static int Create(const char* pFileName, ParserPtr_t& spParser) {
		int   iErr = 0;
		char* pBuf = 0;
		FILE* fpApp = fopen(pFileName, "rb");
		if (0 == fpApp)
			return errno;
		fseek(fpApp, 0, SEEK_END);
		auto fileSize = ftell(fpApp);
		fseek(fpApp, 0, SEEK_SET);
		try {
			if (fileSize <= 0)
				throw ENOENT;
			if (0 == (pBuf = (char*)malloc(fileSize)))
				throw ENOMEM;
			if (fileSize != fread(pBuf, 1, fileSize, fpApp))
				throw errno;
			fclose(fpApp);
			fpApp = 0;

			union {
				MachOParser<mach_header>* p32;
				MachOParser<mach_header_64>* p64;
			} parser;

			switch (*(uint32_t*)pBuf) {
			case MH_MAGIC:
				if (0 != (iErr = MachOParser<mach_header>::CreateInstance((uint8_t*)pBuf, fileSize, parser.p32)))
					throw iErr;
				spParser.reset(parser.p32);
				break;
			case MH_MAGIC_64:
				if (0 != (iErr = MachOParser<mach_header_64>::CreateInstance((uint8_t*)pBuf, fileSize, parser.p64)))
					throw iErr;
				spParser.reset(parser.p64);
				break;
			default:
				throw ENOEXEC;
			}
		}
		catch (int err) {
			if (0 != fpApp)
				fclose(fpApp);
			return err;
		}
		return 0;
	}
};

template< typename T >
MachOParser<T>::MachOParser() : m_pMachO(0)
							  , m_pCmdFirst(0)
							  , m_pCmdLastLoadLib(0)
							  , m_uiFirstSectionRVA(UINT_MAX)
							  , m_sizeFile(0)
{
}

template< typename T >
MachOParser<T>::~MachOParser() { 
	if (0 != m_pMachO)
		free(m_pMachO); 
	m_pMachO = 0; 
}

template< typename T >
int MachOParser<T>::ReloadCommands() {
	union {
		load_command*		pHdr;// Commad header, common to all commands
		dylib_command*		pLoadDyLib;
		segment_command*	pSeg32;
		segment_command_64*	pSeg64;
	} cmds;
	section			*pSections = 0;
	uint8_t			*pPtr = (uint8_t*)m_pCmdFirst;
    m_vecCommands.resize(m_pMachO->ncmds);
	for (uint32_t i = 0; i < m_pMachO->ncmds; i++, pPtr += cmds.pHdr->cmdsize) {
		cmds.pHdr = (load_command*)pPtr;
		m_vecCommands[i] = cmds.pHdr;

		switch (cmds.pHdr->cmd) {
		case LC_LOAD_DYLIB:
			m_pCmdLastLoadLib = cmds.pLoadDyLib;
			break;
		case LC_SEGMENT:
			pSections = (section*)(cmds.pSeg32 + 1);
			for (uint32_t i = 0; i < cmds.pSeg32->nsects; i++) {
				if ((0 != pSections[i].offset) && (pSections[i].offset < m_uiFirstSectionRVA))
					m_uiFirstSectionRVA = pSections[i].offset;
			}
			break;
		case LC_SEGMENT_64:
			pSections = (section*)(cmds.pSeg64 + 1);
			for (uint32_t i = 0; i < cmds.pSeg64->nsects; i++) {
				if ((0 != pSections[i].offset) && (pSections[i].offset < m_uiFirstSectionRVA))
					m_uiFirstSectionRVA = pSections[i].offset;
			}
			break;
		}
	}

	return (UINT_MAX == m_uiFirstSectionRVA) ? ENOEXEC : 0;
}

template< typename T >
bool MachOParser<T>::IsThereEnoughSpaceForCmd(const load_command* pCmd) {
	return (m_pMachO->sizeofcmds + pCmd->cmdsize <= m_uiFirstSectionRVA);
}

template< typename T >
int MachOParser<T>::Attach(uint8_t* pBuf, size_t size) {
	m_pMachO = (T*)pBuf;
	m_sizeFile = size;
	m_pCmdFirst = (load_command*)(m_pMachO + 1);
    return ReloadCommands();
}

template< typename T >
int MachOParser<T>::CreateInstance(uint8_t* pBuf, size_t size, MachOParser* &pParser) {
	if (0 == (pParser = new MachOParser<T>()))
		return ENOMEM;
	int iErr = pParser->Attach(pBuf, size);
	if (0 == iErr)
		return 0;
	delete pParser;
	pParser = 0;
	return iErr;
}

template< typename T >
int MachOParser<T>::Save(const char* pFileName) {
	FILE* fpApp = fopen(pFileName, "wb");
	if (0 == fpApp)
		return errno;
	size_t bytesWritten = fwrite(m_pMachO, 1, m_sizeFile, fpApp);
	const int iRet = (bytesWritten < m_sizeFile) ? errno : 0;
	fclose(fpApp);
	return iRet;
}

template< typename T >// Supports both the 32bit and 64 bit versions of 'mach_header'
bool MachOParser<T>::IsMachOEncrypted() {
	uint8_t*		pPtr = (uint8_t*)m_pCmdFirst;
	load_command*	pCmd = m_pCmdFirst;
	for (uint32_t i = 0; 
		i < m_pMachO->ncmds; 
		i++, pPtr += pCmd->cmdsize, pCmd = (load_command*)pPtr) 
	{
		if (LC_ENCRYPTION_INFO != pCmd->cmd)
			continue;
		if (0 != ((encryption_info_command*)pCmd)->cryptid)
			return true;
		break;// We have found the encryption info section, no need to keep on searching
	}
	return false;
}

template< typename T >// Supports both the 32bit and 64 bit versions of 'mach_header'
int MachOParser<T>::InjectDyLib(const char* pDynLibPath) {
	union {
		dylib_command	cmdInjected;
		char			__pRaw__[512];
	};
	cmdInjected.cmd                         = LC_LOAD_DYLIB;
	cmdInjected.dylib.compatibility_version = 0x00010000;
	cmdInjected.dylib.current_version       = 0x00020000;
	cmdInjected.dylib.timestamp             = 2;
	cmdInjected.dylib.name.offset           = (uint32_t)sizeof(dylib_command);

	char* pLibNameStart = (char*)(&cmdInjected + 1);
	strncpy(pLibNameStart, pDynLibPath, sizeof(__pRaw__)-cmdInjected.dylib.name.offset);
	cmdInjected.cmdsize = cmdInjected.dylib.name.offset + (uint32_t)strlen(pLibNameStart);
	const div_t d = div(cmdInjected.cmdsize, 4);
	if (0 != d.rem) {// Commands size must be aligned to 4
		memset((char*)&cmdInjected + cmdInjected.cmdsize, 0, 4 - d.rem);
		cmdInjected.cmdsize += (4 - d.rem);
	}

	if (FALSE == IsThereEnoughSpaceForCmd((load_command*)&cmdInjected)) {
		// TBD: In case no space is available in the existing MAch-O, enlarge 
		//      the size of the file and update section offsets/RVAs
		return ENOBUFS;
	}

	char* pInjectionOffset = (char*)m_pCmdLastLoadLib + m_pCmdLastLoadLib->cmdsize;
	const char* pLoadCmdsEnd = (char*)m_vecCommands[m_vecCommands.size() - 1] + 
								m_vecCommands[m_vecCommands.size() - 1]->cmdsize;
	// Make space for the new command
	memmove(pInjectionOffset + cmdInjected.cmdsize, 
			pInjectionOffset, 
			(size_t)(pLoadCmdsEnd - pInjectionOffset));
	// Inject the dynlib command 
	memcpy(pInjectionOffset, &cmdInjected, cmdInjected.cmdsize);
	m_pMachO->ncmds++;
	m_pMachO->sizeofcmds += cmdInjected.cmdsize;
	return 0;
}

int main(int argc, const char * argv[]) {
	int iErr = 0;
	MachOParserFactory::ParserPtr_t spParser;
	char pNewFile[260] = { 0 };
	sprintf(pNewFile, "%s.Injected", argv[1]);

	try {
		if (0 != (iErr = MachOParserFactory::Create(argv[1], spParser)))
			throw iErr;
		if (true == spParser->IsMachOEncrypted()) {
			printf("'%s' is FairPlay protected, aborting.\n", argv[1]);
			throw EPERM;
		}
		if (0 != (iErr = spParser->InjectDyLib(argv[2])))
			throw iErr;
		if (0 != (iErr = spParser->Save(pNewFile)))
			throw iErr;
		printf("SUCCESSFULLY Injected '%s'.\n"\
			   "Resulting file: '%s'\n", argv[2], pNewFile);
	} catch (int iErr) {
		printf("FAILED with '%s (%d)'\n", strerror(iErr), iErr);
	}

    return 0;
}
