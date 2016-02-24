//************************************************************************
//**
//** Project......: Control DLL for the Firmware USB AVR Si570 controler.
//**
//** Platform.....: WinXP
//**
//** Licence......: This software is freely available for non-commercial 
//**                use - i.e. for research and experimentation only!
//**
//** Programmer...: F.W. Krom, PE0FKO
//** 
//** Description..: Control the Si570 Freq. PLL chip over the USB port.
//**
//** History......: V1.0 01/06/2009: First release of PE0FKO.
//**
//**************************************************************************
//

#pragma once

#include <tchar.h>

#if defined SRDLL_INCLUDE		// No DLL, direct include the code
#define SRDLL_API
#elif defined SRDLL_EXPORTS		// DLL export or import definitions.
#define SRDLL_API				__declspec(dllexport)
#else
#define SRDLL_API				__declspec(dllimport)
#endif

#define	SRAPI(type,name,arg)	SRDLL_API type __stdcall name arg

#if !defined(BOOL)
#define	BOOL	int
#endif

typedef struct {
	int			VID,PID;
	TCHAR		Manufacturer[128];
	TCHAR		Product[128];
	TCHAR		SerialNumber[128];
} srUsbInfo_t;
 
#ifdef __cplusplus
	extern "C" {
#endif
	// The parameter i2cAddr only needed with old SDR-Kit firmware (V1.4 & V2.0).
	SRAPI(void*, srOpen, (int vid, int pid, const TCHAR* pManufacturer, const TCHAR* pProduct, const TCHAR* pSerialNumber, int iDevNum));
	SRAPI(void,		srClose,				(void));
	SRAPI(BOOL,		srIsOpen,				(void));

	SRAPI(srUsbInfo_t*,	srGetUsbInfo,		(void));
	SRAPI(int,			srGetString,		(int ID, char* pStr, int iLen));

	SRAPI(BOOL,		srGetVersion,			(int* major, int* minor));

	SRAPI(BOOL,		srGetFreqSubMul,		(int index, double* subMHz, double* Mul));
	SRAPI(BOOL,		srSetFreqSubMul,		(int index, double subMHz, double Mul));

	SRAPI(BOOL,		srGetFreq,				(double* MHz));
	SRAPI(BOOL,		srSetFreq,				(double MHz, int i2cAddr));
	
	SRAPI(BOOL,		srGetFreqReg,			(unsigned char reg[6], int i2cAddr, int index));
	SRAPI(BOOL,		srSetFreqReg,			(unsigned char reg[6], int i2cAddr));
	
	SRAPI(BOOL,		srGetXtalFreq,			(double* MHz));
	SRAPI(BOOL,		srSetXtalFreq,			(double MHz));
	
	SRAPI(BOOL,		srGetStartupFreq,		(double* MHz));
	SRAPI(BOOL,		srSetStartupFreq,		(double MHz));
	
	SRAPI(BOOL,		srGetSmoodTuneRange,	(int* range));
	SRAPI(BOOL,		srSetSmoodTuneRange,	(int range));

	SRAPI(BOOL,		srSetI2CAddr,			(int i2c));
	SRAPI(BOOL,		srGetI2CAddr,			(int* pI2C));

	SRAPI(BOOL,		srSetUsbId,				(char Id));
	SRAPI(BOOL,		srGetUsbId,				(char* pId));

	SRAPI(BOOL,		srSetPTTGetCWInp,		(int ptt, int* CWkey));
	SRAPI(BOOL,		srGetCWInp,				(int* CWkey));

	SRAPI(BOOL,		srSetIO,				(int IOdat, int IOddr));
	SRAPI(BOOL,		srGetIO,				(int* IOval));

	SRAPI(BOOL,		srGetFilterRXTable,		(double* pTable, int* pTableLength, BOOL* pEnable));
	SRAPI(BOOL,		srSetFilterRXPoint,		(double Freq, int Entry));
	SRAPI(BOOL,		srSetFilterRXEnable,	(BOOL Enable));

	SRAPI(BOOL,		srGetFilterTXTable,		(double* pTable, int* pTableLength, BOOL* pEnable));
	SRAPI(BOOL,		srSetFilterTXPoint,		(double Freq, int Entry));
	SRAPI(BOOL,		srSetFilterTXEnable,	(BOOL Enable));

	SRAPI(BOOL,		srGetBandRXFilters,		(int* length, int* Filters));
	SRAPI(BOOL,		srSetBandRXFilter,		(int band, int filter));

	SRAPI(BOOL,		srGetBandTXFilters,		(int* length, int* Filters));
	SRAPI(BOOL,		srSetBandTXFilter,		(int band, int filter));

	SRAPI(BOOL,		srSetRegSi570,			(int reg, int value, int i2cAddr, BOOL* pI2CError));

	SRAPI(BOOL,		srReboot,				(void));
	SRAPI(BOOL,		srGetCpuTemp,			(double* pTemp));

	// Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete
	SRAPI(BOOL,		srSetPortDDR,			(int DDR));			// Use srSetIO()
	SRAPI(BOOL,		srGetPortPIN,			(int* pPort));		// Use srGetIO()
	SRAPI(BOOL,		srGetPortPRT,			(int* pPort));		// Not very usefull
	SRAPI(BOOL,		srSetPort,				(int Port));			// Use srSetIO(), Only when no ABPF
	// Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete Obsolete

	//++ Mobo extensions
	SRAPI(BOOL,		srMoboSetPABias,		(int iIndex, int iValue, int* pValue));
	SRAPI(BOOL,		srMoboGetAdc,			(int iIndex, double* pValue, double dMax));

//	SRAPI(BOOL,		srMoboGetAdcPACurrent(double* pCurrent));
//	SRAPI(BOOL,		srMoboGetAdcPAPowerOutput(double* pPower));
//	SRAPI(BOOL,		srMoboGetAdcPAPowerReflected(double* pPower));
//	SRAPI(BOOL,		srMoboGetAdcPAVoltage(double* pVoltage));
//	SRAPI(BOOL,		srMoboGetAdcPATemperature(double* pTemp));
//	SRAPI(BOOL,		srMoboGetAdcPASWR(double* pSWR));
	//-- Mobo extensions

	SRAPI(double,	srFromSi570RegToFreq,	(unsigned char reg[6], double xtal));

	SRAPI(BOOL,		srGetSi570Grade,		(int* pGrade, int* pDCOmin, int* pDCOmax, int* piRFFreqIndex, BOOL* pbFreezeM));
	SRAPI(BOOL,		srSetSi570Grade,		(int iGrade, int iDCOmin, int iDCOmax, int iRfFreqIndex, BOOL bFreezeM));

	extern	SRDLL_API	void*		srUsbHandle;
	extern	SRDLL_API	int			srUsbTimeout;
#ifdef __cplusplus
	};
#endif
	 