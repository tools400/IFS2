**FREE
/IF NOT DEFINED(CLIB)
/DEFINE CLIB

//  Basic C data types
/IF NOT DEFINED(C_DATA_TYPES)
/DEFINE C_DATA_TYPES
// C Data Types
DCL-S char_t CHAR(1) BASED(pDummy);
DCL-S short_t INT(5) BASED(pDummy);
DCL-S ushort_t UNS(5) BASED(pDummy);
DCL-S int_t INT(10) BASED(pDummy);
DCL-S uint_t UNS(10) BASED(pDummy);
DCL-S long_t INT(10) BASED(pDummy);
DCL-S ulong_t UNS(10) BASED(pDummy);
DCL-S float_t FLOAT(4) BASED(pDummy);
DCL-S double_t FLOAT(8) BASED(pDummy);
/ENDIF

//  stdin, stdout and stderr
DCL-S stdin POINTER IMPORT('_C_IFS_stdin');
DCL-S stdout POINTER IMPORT('_C_IFS_stdout');
DCL-S stderr POINTER IMPORT('_C_IFS_stderr');

//  system -- Execute a Command
//     Return value       Meaning
//     ----------------   --------------------------------------
//     0                  the command is successful
//     -1                 for a NULL pointer
//     1                  the command fails
DCL-PR system INT(10) EXTPROC('system');
  i_clCommand POINTER OPTIONS(*STRING) VALUE;
END-PR;

DCL-S EXCP_MSGID CHAR(7) IMPORT('_EXCP_MSGID');

//  time -- Determine Current Time
//     The time() function returns the current calendar time.
//     The return value is also stored in the location that
//     is given by timeptr.
DCL-PR time INT(10) EXTPROC('time');
  timeptr POINTER VALUE;
END-PR;

//  strftime -- Convert to Formatted Time
//     strftime() returns the number of bytes placed into the
//     array pointed to by 'dest'.
DCL-PR strftime INT(10) EXTPROC('strftime');
  dest    POINTER VALUE;
  maxsize INT(10) VALUE;
  format  POINTER OPTIONS(*STRING) VALUE;
  timeptr LIKEDS(tm_t) CONST;
END-PR;

DCL-DS tm_t QUALIFIED BASED(pDummy);
  tm_sec   INT(10);
  tm_min   INT(10);
  tm_hour  INT(10);
  tm_mday  INT(10);
  tm_mon   INT(10);
  tm_year  INT(10);
  tm_wday  INT(10);
  tm_yday  INT(10);
  tm_isdst INT(10);
END-DS;

//  localtime() -- Correct Local Time, returns tm_t*
//     The localtime() function converts a time value, in
//     seconds, to a structure of type tm.
DCL-PR localtime POINTER EXTPROC('localtime');
  time INT(10) CONST;
END-PR;

//  localtime_r() -- Correct Local Time
//     It is the same as localtime() except that it passes
//     in the place to store the returned structure result.
DCL-PR localtime_r POINTER EXTPROC('localtime_r');
  time INT(10) CONST;
  tm   LIKEDS(tm_t) CONST;
END-PR;

//  strtok -- Tokenize String
//     The first time the strtok() function is called, it returns
//     a pointer to the first token in i_string. In later calls
//     it returns a pointer to the next token. A null pointer is
//     returned when there are no more tokens.
DCL-PR strtok POINTER EXTPROC('strtok');
  i_string     POINTER OPTIONS(*STRING) VALUE;
  i_delimiters POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  atoi -- Convert Character String to Integer
//     The atoi() function returns an int value of the
//     interpreted input string.
DCL-PR atoi INT(10) EXTPROC('atoi');
  i_string POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  memcpy -- Copy Bytes
//     The behavior is undefined if copying takes place
//     between objects that overlap.
//     The memcpy() function returns a pointer to dest.
DCL-PR memcpy POINTER EXTPROC('memcpy');
  i_pDest POINTER VALUE;
  i_pSrc  POINTER VALUE;
  i_count UNS(10) VALUE;
END-PR;

//  memset -- Set Bytes to Value
//     The memset() function returns a pointer to dest.
DCL-PR memset POINTER EXTPROC('memset');
  i_pDest POINTER VALUE;
  i_char  INT(10) VALUE;
  i_count UNS(10) VALUE;
END-PR;

//  memmove -- Copy Bytes
//     memmove allows copying between objects that may overlap
//     as if src is first copied into a temporary array.
//     The memmove() function returns a pointer to dest.
DCL-PR memmove POINTER EXTPROC('memmove');
  pMemDest POINTER VALUE;
  pMemSrc  POINTER VALUE;
  memSize  LIKE(size_t) VALUE;
END-PR;

//  memcmp -- Compare Buffers
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        buf1 less than buf2
//     0                  buf1 identical to buf2
//     Greater than 0     buf1 greater than buf2
DCL-PR memcmp INT(10) EXTPROC('memcmp');
  pBuf1 POINTER VALUE;
  pBuf2 POINTER VALUE;
  count LIKE(size_t) VALUE;
END-PR;

//  memicmp -- Compare Bytes (ignore case)
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        buf1 less than buf2
//     0                  buf1 identical to buf2
//     Greater than 0     buf1 greater than buf2
DCL-PR memicmp INT(10) EXTPROC('__memicmp');
  pBuf1 POINTER VALUE;
  pBuf2 POINTER VALUE;
  count UNS(10) VALUE;
END-PR;

//  strcmp() -- Compare Strings
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        string 1 less than string 2
//     0                  string 1 equivalent to string 2
//     Greater than 0     string 1 greater than string 2
DCL-PR strcmp INT(10) EXTPROC('strcmp');
  string1 POINTER OPTIONS(*STRING) VALUE;
  string2 POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  strcasecmp() -- Compare Strings without Case Sensitivity
//     Return value       Meaning
//     ----------------   --------------------------------------
//     Less than 0        string 1 less than string 2
//     0                  string 1 equivalent to string 2
//     Greater than 0     string 1 greater than string 2
DCL-PR strcasecmp INT(10) EXTPROC('strcasecmp');
  string1 POINTER OPTIONS(*STRING) VALUE;
  string2 POINTER OPTIONS(*STRING) VALUE;
END-PR;
/IF NOT DEFINED(TESTPTR)
/DEFINE TESTPTR

//  Test Pointer (TESTPTR)
DCL-PR testptr INT(10) EXTPROC('_TESTPTR');
  i_ptr       POINTER VALUE;
  i_test_type INT(10) VALUE;
END-PR;

DCL-C cTESTPTR_TYPE_PROCPTR 0;
DCL-C cTESTPTR_NO_OPTIMIZED_PARAMETER_PASSING 0;
DCL-C cTESTPTR_OPTIMIZED_PARAMETER_PASSING 1;

DCL-C cTESTPTR_TYPE_MEMPTR 1;
DCL-C cTESTPTR_NON_TERASPACE 0;
DCL-C cTESTPTR_TERASPACE 1;

DCL-C cTESTPTR_ERROR_NOT_EXIST x'2401';
DCL-C cTESTPTR_ERROR_INVALID x'2402';
DCL-C cTESTPTR_ERROR_OBJECT_DESTROYED x'2202';
/ENDIF

//  malloc() - Reserve Storage Block
DCL-PR TS_malloc POINTER EXTPROC('_C_TS_malloc');
  i_size UNS(10) VALUE;
END-PR;

//  realloc() - Change Reserved Storage Block Size
DCL-PR TS_realloc POINTER EXTPROC('_C_TS_realloc');
  i_pMem POINTER VALUE;
  i_size UNS(10) VALUE;
END-PR;

//  free() - Release Storage Blocks
DCL-PR TS_free EXTPROC('_C_TS_free');
  i_pMem POINTER VALUE;
END-PR;

//  _C_TS_malloc_info() - Determine amount of teraspace memory used
DCL-PR TS_malloc_info INT(10) EXTPROC('_C_TS_malloc_info');
  o_c_mallinfo LIKEDS(C_mallinfo_t) CONST;
  i_size       UNS(10) VALUE;
END-PR;

//  _C_TS_malloc_debug() - Determine amount of teraspace memory
//                         used (with optional dumps and verification)
DCL-PR TS_malloc_debug INT(10) EXTPROC('_C_TS_malloc_debug');
  i_dump_level UNS(10) VALUE;
  i_vrfy_level UNS(10) VALUE;
  o_c_mallinfo LIKEDS(C_mallinfo_t) CONST;
  i_size       UNS(10) VALUE;
END-PR;

// The following are possible values for the dump_level parameter
DCL-C C_NO_DUMPS 0;
//  Dumps the _C_mallinfo_t structure:
DCL-C C_DUMP_TOTALS 1;
//  Does a hex dump of all allocated chunks of teraspace storage,
//  this is the entire 512K chunk of storage:
DCL-C C_DUMP_CHUNKS 2;
//  Dumps each of the allocated nodes.
//  There is a node for each malloc performed with the header
//  associated with that malloc:
DCL-C C_DUMP_NODES 3;
//  Dumps the cartesian tree used to keep track of the freed nodes:
DCL-C C_DUMP_TREE 4;
DCL-C C_DUMP_ALL 9999;

//  The following are possible values for the verify_level parameter
DCL-C C_NO_CHECKS 0;
DCL-C C_CHECK_TOTALS 1;
DCL-C C_CHECK_CHUNKS 2;
DCL-C C_CHECK_NODES 3;
DCL-C C_CHECK_TREE 4;
DCL-C C_CHECK_ALL 9998;
//  Will call abort() if verification fails
DCL-C C_CHECK_ALL_AND_ABORT 9999;

// The following structure is used to return information
// from the _C_TS_malloc_info routine.  The fields are:
//   total_bytes        - bytes allocated from system
//                        (high water mark)
//   allocated_bytes    - number of allocated bytes
//   unallocated_bytes  - number of unallocated bytes
//   allocated_blocks   - number of allocated blocks
//   unallocated_blocks - number of unallocated blocks
//   requested_bytes    - bytes actually requested from malloc
//   pad_bytes          - bytes used to pad allocation length
//                        to a multiple of 16
//   overhead_bytes     - bytes used for malloc overhead
DCL-DS C_mallinfo_t QUALIFIED BASED(pDummy);
  total_bytes        INT(20);
  allocated_bytes    INT(20);
  unallocated_bytes  INT(20);
  allocated_blocks   INT(20);
  unallocated_blocks INT(20);
  requested_bytes    INT(20);
  pad_bytes          INT(20);
  overhead_bytes     INT(20);
END-DS;

//  malloc -- Reserve Storage Block
DCL-PR malloc POINTER EXTPROC('malloc');
  i_size UNS(10) VALUE;
END-PR;

//  realloc -- Change Reserved Storage Block Size
DCL-PR realloc POINTER EXTPROC('realloc');
  i_pMem POINTER VALUE;
  i_size UNS(10) VALUE;
END-PR;

//  free -- Release Storage Blocks
DCL-PR free EXTPROC('free');
  i_pMem POINTER VALUE;
END-PR;

//  srand -- Set Seed for rand Function   e.g.:   srand(getSeed(*null))
DCL-PR srand EXTPROC('srand');
  i_seed UNS(10) VALUE;
END-PR;

//  rand -- Generate Random Number                x = rand()
DCL-PR rand INT(10) EXTPROC('rand');
END-PR;

DCL-C RAND_MAX 32767;

//  getSeed -- Get Seed for srand function
DCL-PR getSeed INT(10) EXTPROC('time');
  i_timePtr POINTER VALUE;
END-PR;

//  strlen -- Determine String Length
DCL-PR strlen UNS(10) EXTPROC('strlen');
  i_string POINTER VALUE;
END-PR;

//  tmpnam -- Produce Temporary File Name
DCL-PR tmpnam POINTER EXTPROC('tmpnam');
  pTmpNme POINTER VALUE;
END-PR;

//  _C_IFS_tmpnam -- Produce Temporary File Name for the IFS file system
DCL-PR ifs_tmpnam POINTER EXTPROC('_C_IFS_tmpnam');
  fileName POINTER VALUE;
END-PR;

DCL-C L_tmpnam 39; // ! <stdio.h>

DCL-C TMP_MAX 32767; // ! <stdio.h>

//  qsort -- Sort Array
DCL-PR qsort POINTER EXTPROC('qsort');
  memPtr    POINTER VALUE;
  numElem   LIKE(size_t) VALUE;
  width     LIKE(size_t) VALUE;
  pSortFunc POINTER(*PROC) VALUE;
END-PR;

//  bsearch -- Search Arrays
DCL-PR bsearch POINTER EXTPROC('bsearch');
  keyPtr     POINTER VALUE;
  memPtr     POINTER VALUE;
  numElem    LIKE(size_t) VALUE;
  width      LIKE(size_t) VALUE;
  pSearchFnc POINTER(*PROC) VALUE;
END-PR;

//  iconv_open()--Code Conversion Allocation API
DCL-PR iconv_open EXTPROC('iconv_open') LIKE(iconv_t);
  i_toCode   POINTER VALUE;
  i_fromCode POINTER VALUE;
END-PR;

DCL-DS iconv_t QUALIFIED BASED(pDummy) ALIGN;
  return_value INT(10);
  cd           INT(10) DIM(12);
END-DS;

DCL-DS iconv_fromcode_t QUALIFIED BASED(pDummy);
  ibmccsid      CHAR(8);
  ccsid         CHAR(5);
  convAlt       CHAR(3);
  substAlt      CHAR(1);
  shiftStateAlt CHAR(1);
  inpLengthOpt  CHAR(1);
  errOption     CHAR(1);
  reserved      CHAR(12);
END-DS;

DCL-DS iconv_tocode_t QUALIFIED BASED(pDummy);
  ibmccsid CHAR(8);
  ccsid    CHAR(5);
  reserved CHAR(19);
END-DS;

//  QtqIconvOpen()--Code Conversion Allocation API
DCL-PR QtqIconv_open EXTPROC('QtqIconvOpen') LIKEDS(iconv_t);
  i_toCode   LIKEDS(QtqCode_t) CONST;
  i_fromCode LIKEDS(QtqCode_t) CONST;
END-PR;

DCL-DS QtqCode_t QUALIFIED BASED(pDummy);
  ccsid         INT(10);
  conversionA   INT(10);
  substitutionA INT(10);
  shiftStateA   INT(10);
  inpLenOpt     INT(10);
  errOptMxdDta  INT(10);
  reserved      CHAR(12);
END-DS;

//  iconv()--Code Conversion API
DCL-PR iconv UNS(10) EXTPROC('iconv');
  i_cd         LIKEDS(iconv_t) VALUE;
  i_pInBuf     POINTER;
  i_inBytLeft  UNS(10);
  i_pOutBuf    POINTER;
  i_outBytLeft UNS(10);
END-PR;

DCL-C cICONV_ERROR 4294967295;

//  iconv_close()--Code Conversion Deallocation API
DCL-PR iconv_close INT(10) EXTPROC('iconv_close');
  i_cd LIKEDS(iconv_t) VALUE;
END-PR;

//  0/-1 = stat()--Get File Information                include <sys/stat.h>
DCL-PR stat INT(10) EXTPROC('stat'); // = int
  i_pPath POINTER OPTIONS(*STRING) VALUE; // = *path
  i_pStat POINTER VALUE; // = *buf
END-PR;

//  0/-1 = fstat()--Get File Information by Descriptor include <sys/stat.h>
DCL-PR fstat INT(10) EXTPROC('fstat'); // = int
  i_fd   INT(10) VALUE; // = int
  i_stat LIKEDS(st_stat_t) CONST; // = *buf
END-PR;

//  0/-1 = lstat()--Get File or Link Information       include <sys/stat.h>
DCL-PR lstat INT(10) EXTPROC('lstat'); // = int
  i_pPath POINTER OPTIONS(*STRING) VALUE; // = *path
  i_pStat POINTER VALUE; // = *buf
END-PR;

DCL-DS st_stat_t QUALIFIED BASED(pDummy) ALIGN;
  mode       UNS(10); // mode_t =uint
  ino        UNS(10); // ino_t  =uint
  nlink      UNS(5); // nlink_t=ushort
  reserved2  CHAR(2);
  uid        UNS(10); // uid_t  =uint
  gid        UNS(10); // gid_t  =uint
  size       INT(10); // off_t  =int
  atime      INT(10); // time_t =long
  mtime      INT(10); // time_t =long
  ctime      INT(10); // time_t =long
  dev        UNS(10); // dev_t  =uint
  blksize    UNS(10); // size_t =uint
  allocsize  UNS(10); // ulong
  objtype    CHAR(11); // qp0l_objtype_t
  reserved3  CHAR(1);
  codepage   UNS(5); // ushort
  ccsid      UNS(5); // ushort
  rdev       UNS(10); // dev_t  =uint
  nlink32    UNS(10); // nlink32_t=ulng
  rdev64     UNS(20); // dev64_t=ullng
  dev64      UNS(20); // dev64_t=ullng
  reserved1  CHAR(36);
  ino_gen_id UNS(10); // uint
END-DS;

//  Qp0lGetAttr()--Get Attributes
DCL-PR Qp0lGetAttr INT(10) EXTPROC('Qp0lGetAttr');
  i_path       LIKEDS(Qlg_Path_Name_t) CONST;
  i_attrArray  LIKE(Qlg_attrArray_t) CONST;
  i_pBuffer    POINTER VALUE;
  i_bytPrv     UNS(10) VALUE;
  o_sizeNeeded UNS(10);
  o_bytRet     UNS(10);
  i_followLnk  UNS(10) VALUE;
END-PR;

/IF not DEFINED(Qlg_Path_Name)
/DEFINE Qlg_Path_Name
DCL-DS Qlg_Path_Name_t QUALIFIED ALIGN BASED(pDummy);
  CCSID               INT(10);
  Country_ID          CHAR(2);
  Language_ID         CHAR(3);
  Reserved            CHAR(3);
  Path_Type           UNS(10);
  Path_Length         INT(10);
  Path_Name_Delimiter CHAR(2);
  Reserved2           CHAR(10);
  Path_Name           CHAR(256);
END-DS;

DCL-C QLG_PATH_JOB_CCSID 0;
DCL-C QLG_PATH_JOB_COUNTRYID X'0000';
DCL-C QLG_PATH_JOB_LANGUAGEID X'000000';

//  The Path_Name is a character string and the delimiter is one byte long.
DCL-C QLG_CHAR_SINGLE 0;

//  The Path_Name is a pointer and the delimiter is one byte long.
DCL-C QLG_PTR_SINGLE 1;

//  The Path_Name is a character string and the delimiter is two bytes long.
DCL-C QLG_CHAR_DOUBLE 2;

//  The Path_Name is a pointer and the delimiter is two bytes long.
DCL-C QLG_PTR_DOUBLE 3;

/ENDIF

DCL-DS Qlg_attrArray_t QUALIFIED BASED(pDummy);
  numE INT(10);
  attr INT(10) DIM(64);
END-DS;

DCL-DS Qlg_rtnAttr_t QUALIFIED BASED(pDummy);
  ofsNextAttr INT(10);
  ID          INT(10);
  size        INT(10);
  reserved    CHAR(4);
END-DS;

DCL-C QP0L_ATTR_OBJTYPE 0; // CHAR(10)
DCL-C QP0L_ATTR_DATA_SIZE 1; // UINT(4)
DCL-C QP0L_ATTR_ALLOC_SIZE 2; // UINT(4)
DCL-C QP0L_ATTR_EXTENDED_ATTR_SIZE 3; // UINT(4)
DCL-C QP0L_ATTR_CREATE_TIME 4; // UINT(4)
DCL-C QP0L_ATTR_ACCESS_TIME 5; // UINT(4)
DCL-C QP0L_ATTR_CHANGE_TIME 6; // UINT(4)
DCL-C QP0L_ATTR_MODIFY_TIME 7; // UINT(4)
DCL-C QP0L_ATTR_STG_FREE 8; // CHAR(1)
DCL-C QP0L_ATTR_CHECKED_OUT 9; // chkOut Fmt
DCL-C QP0L_ATTR_LOCAL_REMOTE 10; // CHAR(1)

DCL-C QP0L_DONOT_FOLLOW_SYMLNK x'00';
DCL-C QP0L_FOLLOW_SYMLNK x'01';

DCL-C QP0L_NOT_CHECKED_OUT x'00';
DCL-C QP0L_CHECKED_OUT x'01';

DCL-C QP0L_LOCAL_OBJ x'01';
DCL-C QP0L_REMOTE_OBJ x'02';

//  QlgGetcwd()--Get Current Directory (using NLS-enabled path name)
//  Returns: Qlg_Path_Name_T
DCL-PR QlgGetcwd POINTER EXTPROC('QlgGetcwd');
  o_path LIKEDS(Qlg_Path_Name_t) CONST;
  i_size LIKE(size_t) VALUE;
END-PR;

//  getcwd()--Get Current Directory
DCL-PR getcwd POINTER EXTPROC('getcwd');
  o_path CHAR(65535) OPTIONS(*VARSIZE) CONST;
  i_size LIKE(size_t) VALUE;
END-PR;

//  QlgChdir()--Change Current Directory (using NLS-enabled path name)
//  Returns: Qlg_Path_Name_T
DCL-PR QlgChdir INT(10) EXTPROC('QlgChdir');
  i_path LIKEDS(Qlg_Path_Name_t) CONST;
END-PR;

//  chdir()--Change Current Directory
DCL-PR chdir INT(10) EXTPROC('chdir');
  i_path POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  QSYSINC/SYS.TYPES
DCL-S off_t INT(10) BASED(pDummy);
DCL-S size_t UNS(10) BASED(pDummy);
DCL-S ssize_t INT(10) BASED(pDummy);
DCL-S time_t INT(10) BASED(pDummy);

//  0/-1 = chmod()--Change File Authorizations         include <sys/stat.h>
DCL-PR chmod INT(10) EXTPROC('chmod'); // = int
  i_pPath POINTER OPTIONS(*STRING) VALUE; // = *path
  i_mode  UNS(10) VALUE; // = mode_t =uint
END-PR;

//  mkdir()--Make Directory                            include <sys/stat.h>
DCL-PR mkdir INT(10) EXTPROC('mkdir'); // = rc
  i_pPath POINTER OPTIONS(*STRING) VALUE; // = *path
  i_mode  UNS(10) VALUE; // = mode_t =uint
END-PR;

//  rmdir()--Remove Directory                          include <sys/stat.h>
DCL-PR rmdir INT(10) EXTPROC('rmdir'); // = rc
  i_pPath POINTER OPTIONS(*STRING) VALUE; // = *path
END-PR;

//  opendir()--Open Directory                          include <dirent.h>
DCL-PR opendir POINTER EXTPROC('opendir'); // = *DIR
  i_pDirName POINTER OPTIONS(*STRING) VALUE; // = *dirname
END-PR;

//  readdir()--Read Directory Entry
DCL-PR readdir POINTER EXTPROC('readdir'); // = *dirent
  i_dirp POINTER VALUE; // = *DIR
END-PR;

DCL-DS dirent_t QUALIFIED BASED(pDummy);
  d_reserv1       CHAR(16);
  d_fileno_gen_id UNS(10);
  d_fileno        UNS(10);
  d_reclen        UNS(10);
  d_reserv3       INT(10);
  d_reserv4       CHAR(8);
/IF not DEFINED(*V5R2M0)
  d_nlsinfo       LIKE(qlg_nls_t);
/ELSE
  d_nlsinfo       LIKEDS(qlg_nls_t);
/ENDIF
  d_namelen       UNS(10);
  d_name          CHAR(640);
END-DS;

DCL-DS qlg_nls_t QUALIFIED BASED(pDummy) ALIGN;
  ccsid        INT(10);
  country_id   CHAR(2);
  language_id  CHAR(3);
  nls_reserved CHAR(3);
END-DS;

//  rewinddir()--Reset Directory Stream to Beginning
DCL-PR rewinddir EXTPROC('rewinddir');
  i_dirp POINTER VALUE; // = *DIR
END-PR;

//  closedir()--Close Directory
DCL-PR closedir INT(10) EXTPROC('closedir'); // = rc
  i_dirp POINTER VALUE; // = *DIR
END-PR;

//  fd/-1 = open()--Open File                          include <fcntl.h>
DCL-PR open INT(10) EXTPROC('open'); // = int
  i_pPath       POINTER OPTIONS(*STRING) VALUE; // = *path
  i_opnFLag     INT(10) VALUE; // = int
  i_mode        UNS(10) OPTIONS(*NOPASS) VALUE; // = uint
  i_codePage    UNS(10) OPTIONS(*NOPASS) VALUE; // = uint
  i_crtCodePage UNS(10) OPTIONS(*NOPASS) VALUE; // = uint
END-PR;

//  <sys/stat.h>
DCL-C S_IRUSR 256; // ! Read For Own
DCL-C S_IWUSR 128; // ! Write For Ow
DCL-C S_IXUSR 64; // ! Exc/Srch For
DCL-C S_IRWXU 448; // ! Rd/Wrt/Exc O

DCL-C S_IRGRP 32; // ! Read For Gro
DCL-C S_IWGRP 16; // ! Write For Gr
DCL-C S_IXGRP 8; // ! Exc/Srch For
DCL-C S_IRWXG 56; // ! Rd/Wrt/Exc G

DCL-C S_IROTH 4; // ! Read For Oth
DCL-C S_IWOTH 2; // ! Write For Ot
DCL-C S_IXOTH 1; // ! Exc/Srch For
DCL-C S_IRWXO 7; // ! Rd/Wrt/Exc O

DCL-C S_ISUID 2048;
DCL-C S_ISGID 1024;
DCL-C S_ISVTX 512;

//  <h/fcntl.h>
DCL-C O_CREAT 8; // ! Append Mode
DCL-C O_EXCL 16; // ! Exclusive Us
DCL-C O_TRUNC 64; // ! Truncate Fla

DCL-C O_APPEND 256; // ! Append Mode

DCL-C O_CODEPAGE 8388608; // ! Codepage Fla
DCL-C O_TEXTDATA 16777216; // ! Text Data Fl
DCL-C O_FORCE_SCAN 67108864; // ! Force scan
DCL-C O_INHERITMODE 134217728; // ! Inherit Mode
DCL-C O_CCSID 32; // ! CCSID
DCL-C O_TEXT_CREAT 33554432; // !

DCL-C O_SHARE_RDONLY 65536; // ! Shared Read
DCL-C O_SHARE_WRONLY 131072; // ! Shared Write
DCL-C O_SHARE_RDWR 262144; // ! Shared Rd/Wr
DCL-C O_SHARE_NONE 524288; // ! No Share

DCL-C O_RDONLY 1; // ! Read Only
DCL-C O_WRONLY 2; // ! Write Only
DCL-C O_RDWR 4; // ! Read/Write

//  value/-1 = read()--Write from Descriptor           include <unistd.h>
DCL-PR read EXTPROC('read') LIKE(ssize_t); // = ssize_t
  i_fd      INT(10) VALUE; // = int
  i_pBuffer POINTER VALUE; // = *buf
  i_buflen  LIKE(size_t) VALUE; // = size_t
END-PR;

//  value/-1 = write()--Write to Descriptor            include <unistd.h>
DCL-PR write EXTPROC('write') LIKE(ssize_t); // = ssize_t
  i_fd      INT(10) VALUE; // = int
  i_pBuffer POINTER VALUE; // = *buf
  i_buflen  LIKE(size_t) VALUE; // = size_t
END-PR;

//  0/-1 = ftruncate()--Truncate File                  include <unistd.h>
DCL-PR ftruncate INT(10) EXTPROC('ftruncate'); // = int
  i_fd     INT(10) VALUE; // = int
  i_length LIKE(off_t) VALUE; // = off_t
END-PR;

//  off_t = lseek()--Set File Read/Write Offset        include <unistd.h>
DCL-PR lseek EXTPROC('lseek') LIKE(off_t); // = off_t
  i_fd     INT(10) VALUE; // = int
  i_offset LIKE(off_t) VALUE; // = off_t
  i_whence INT(10) VALUE; // = int
END-PR;

//  <h/unistd.h>
DCL-C SEEK_SET 0; // ! seek start
DCL-C SEEK_CUR 1; // ! seek curPos
DCL-C SEEK_END 2; // ! seek end

//  0/-1 = unlink()--Remove Link to File               include <unistd.h>
DCL-PR unlink INT(10) EXTPROC('unlink'); // = int
  i_pPath POINTER OPTIONS(*STRING) VALUE; // = *path
END-PR;

//  0/-1 = Qp0lRenameKeep()--Rename File or Directory, Keep "new" If It Exists
DCL-PR Qp0lRenameKeep INT(10) EXTPROC('Qp0lRenameKeep'); // = int
  i_pOldPath POINTER OPTIONS(*STRING) VALUE; // = *path
  i_pNewPath POINTER OPTIONS(*STRING) VALUE; // = *path
END-PR;

//  0/-1 = Qp0lRenameUnlink()--Rename File or Directory, Unlink "new" If It Exists
DCL-PR Qp0lRenameUnlink INT(10) EXTPROC('Qp0lRenameUnlink'); // = int
  i_pOldPath POINTER OPTIONS(*STRING) VALUE; // = *path
  i_pNewPath POINTER OPTIONS(*STRING) VALUE; // = *path
END-PR;

//  0/-1 = close()--Close File or Socket Descriptor    include <unistd.h>
/IF NOT DEFINED(c_close_function)
/DEFINE c_close_function
DCL-PR close INT(10) EXTPROC('close'); // = int
  i_fd INT(10) VALUE; // = int
END-PR;
/ENDIF

//  erno--Set Pointer to Runtime Error Code
DCL-PR errno POINTER EXTPROC('__errno');
END-PR;

//  strerror -- Set Pointer to Runtime Error Message
DCL-PR strerror POINTER EXTPROC('strerror');
  errno INT(10) VALUE;
END-PR;

//  <sys/errno.h>
DCL-C EDOM_C 3001; // domain error i
DCL-C ERANGE_C 3002; // range error in
DCL-C ETRUNC_C 3003; // truncation on
DCL-C ENOTOPEN_C 3004; // file has not b
DCL-C ENOTREAD_C 3005; // file not opene
DCL-C ERECIO_C 3008; // file opened fo
DCL-C ENOTWRITE_C 3009; // file not opene
DCL-C ESTDIN_C 3010; // stdin cannot b
DCL-C ESTDOUT_C 3011; // stdout cannot
DCL-C ESTDERR_C 3012; // stderr cannot
DCL-C EBADSEEK_C 3013; // bad offset to
DCL-C EBADNAME_C 3014; // invalid file n
DCL-C EBADMODE_C 3015; // invalid file m
DCL-C EBADPOS_C 3017; // invalid positi
DCL-C ENOPOS_C 3018; // no record at s
DCL-C ENUMMBRS_C 3019; // no ftell if mo
DCL-C ENUMRECS_C 3020; // no ftell if to
DCL-C EBADFUNC_C 3022; // invalid functi
DCL-C ENOREC_C 3026; // record not fou
DCL-C EBADDATA_C 3028; // message data i
DCL-C EBADOPT_C 3040; // bad option on
DCL-C ENOTUPD_C 3041; // file not opene
DCL-C ENOTDLT_C 3042; // file not opene
DCL-C EPAD_C 3043; // padding occurr
DCL-C EBADKEYLN_C 3044; // bad key length
DCL-C EPUTANDGET_C 3080; // illegal write
DCL-C EGETANDPUT_C 3081; // illegal read a
DCL-C EIOERROR_C 3101; // I/O exception
DCL-C EIORECERR_C 3102; // I/O exception

//  The following values are defined by POSIX ISO/IEC 9945-1:1990.
DCL-C EINVAL_C 3021; // invalid argume
DCL-C EIO_C 3006; // input/output e
DCL-C ENODEV_C 3007; // no such device
DCL-C EBUSY_C 3029; // resource busy
DCL-C ENOENT_C 3025; // no such file o
DCL-C EPERM_C 3027; // operation not

//  AS/400 specific error numbers
DCL-C EACCES_C 3401; // Permission den
DCL-C ENOTDIR_C 3403; // Not a director
DCL-C ENOSPC_C 3404; // No space avail
DCL-C EXDEV_C 3405; // Improper link.
DCL-C EWOULDBLOCK_C 3406; // Operation woul
DCL-C EAGAIN_C 3406; // Operation woul
DCL-C EINTR_C 3407; // Interrupted fu
DCL-C EFAULT_C 3408; // The address us
DCL-C ETIME_C 3409; // Operation time
DCL-C ENXIO_C 3415; // No such device
DCL-C ECLOSED_C 3417; // Socket closed
DCL-C EADDRINUSE_C 3420; // Address alread
DCL-C EADDRNOTAVAIL_C 3421; // Address not av
DCL-C EAFNOSUPPORT_C 3422; // The type of so
DCL-C EALREADY_C 3423; // Operation alre
DCL-C ECONNABORTED_C 3424; // Connection end
DCL-C ECONNREFUSED_C 3425; // A remote host
DCL-C ECONNRESET_C 3426; // A connection w
DCL-C EDESTADDRREQ_C 3427; // Operation requ
DCL-C EHOSTDOWN_C 3428; // A remote host
DCL-C EHOSTUNREACH_C 3429; // A route to the
DCL-C EINPROGRESS_C 3430; // Operation in p
DCL-C EISCONN_C 3431; // A connection h
DCL-C EMSGSIZE_C 3432; // Message size o
DCL-C ENETDOWN_C 3433; // The network is
DCL-C ENETRESET_C 3434; // A socket is co
DCL-C ENETUNREACH_C 3435; // Cannot reach t
DCL-C ENOBUFS_C 3436; // There is not e
DCL-C ENOPROTOOPT_C 3437; // The protocol d
DCL-C ENOTCONN_C 3438; // Requested oper
DCL-C ENOTSOCK_C 3439; // The specified
DCL-C ENOTSUP_C 3440; // Operation not
DCL-C EOPNOTSUPP_C 3440; // Operation not
DCL-C EPFNOSUPPORT_C 3441; // The socket pro
DCL-C EPROTONOSUPPORT_C 3442; // No protocol of
DCL-C EPROTOTYPE_C 3443; // The socket typ
DCL-C ERCVDERR_C 3444; // An error indic
DCL-C ESHUTDOWN_C 3445; // Cannot send da
DCL-C ESOCKTNOSUPPORT_C 3446; // The specified
DCL-C ETIMEDOUT_C 3447; // A remote host
DCL-C EUNATCH_C 3448; // The protocol r
DCL-C EBADF_C 3450; // Descriptor not
DCL-C EMFILE_C 3452; // Too many open
DCL-C ENFILE_C 3453; // Too many open
DCL-C EPIPE_C 3455; // Broken pipe.
DCL-C EEXIST_C 3457; // File exists.
DCL-C EDEADLK_C 3459; // Resource deadl
DCL-C ENOMEM_C 3460; // Storage alloca
DCL-C EOWNERTERM_C 3462; // The mutex no l
DCL-C EDESTROYED_C 3463; // he synchroniza
DCL-C ETERM_C 3464; // Operation term
DCL-C EMLINK_C 3468; // Maximum link c
DCL-C ESPIPE_C 3469; // Seek request n
DCL-C ENOSYS_C 3470; // Function not i
DCL-C EISDIR_C 3471; // Specified targ
DCL-C EROFS_C 3472; // Read-only file
DCL-C EUNKNOWN_C 3474; // Unknown system
DCL-C EITERBAD_C 3475; // Iterator is in
DCL-C EDAMAGE_C 3484; // A damaged obje
DCL-C ELOOP_C 3485; // A loop exists
DCL-C ENAMETOOLONG_C 3486; // A path name is
DCL-C ENOLCK_C 3487; // No locks avail
DCL-C ENOTEMPTY_C 3488; // Directory not
DCL-C ENOSYSRSC_C 3489; // System resourc
DCL-C ECONVERT_C 3490; // Conversion err
DCL-C E2BIG_C 3491; // Argument list
DCL-C EILSEQ_C 3492; // Conversion sto
DCL-C ESOFTDAMAGE_C 3497; // Object has sof
DCL-C ENOTENROLL_C 3498; // User not enrol
DCL-C EOFFLINE_C 3499; // Object is susp
DCL-C EROOBJ_C 3500; // Object is a re
DCL-C ELOCKED_C 3506; // Area being rea
DCL-C EFBIG_C 3507; // Object too lar
DCL-C EIDRM_C 3509; // The semaphore,
DCL-C ENOMSG_C 3510; // The queue does
DCL-C EFILECVT_C 3511; // File ID conver
DCL-C EBADFID_C 3512; // A File ID coul
DCL-C ESTALE_C 3513; // A File ID coul
DCL-C ESRCH_C 3515; // No such proces
DCL-C ENOTSIGINIT_C 3516; // Process not en
DCL-C ECHILD_C 3517; // No child proce
DCL-C EBADH_C 3520; // Handle is not
DCL-C ETOOMANYREFS_C 3523; // The operation
DCL-C ENOTSAFE_C 3524; // Function not a
DCL-C EOVERFLOW_C 3525; // Object is too
DCL-C EJRNDAMAGE_C 3526; // Journal damage
DCL-C EJRNINACTIVE_C 3527; // Journal inacti
DCL-C EJRNRCVSPC_C 3528; // Journal space
DCL-C EJRNRMT_C 3529; // Journal is rem
DCL-C ENEWJRNRCV_C 3530; // New journal re
DCL-C ENEWJRN_C 3531; // New journal is
DCL-C EJOURNALED_C 3532; // Object already
DCL-C EJRNENTTOOLONG_C 3533; // Entry too larg
DCL-C EDATALINK_C 3534; // Object is a Da
DCL-C ENOTAVAIL_C 3535; // Independent AS
DCL-C ENOTTY_C 3536; // Inappropriate
DCL-C EFBIG2_C 3540; // Write or trunc
DCL-C ETXTBSY_C 3543; // Text file busy
DCL-C EASPGRPNOTSET_C 3544; // ASP group not
DCL-C ERESTART_C 3545; // System call ca
DCL-C ESCANFAILURE_C 3546; // Object marked

//  Unix return codes
DCL-C RC_OK 0;
DCL-C RC_ERROR -1;

//  Convert External Form to Numeric Value (CVTEFN)
DCL-PR cvtefnd FLOAT(8) EXTPROC('cvtefnd');
  i_source POINTER VALUE;
  i_len    UNS(10) VALUE;
  i_mask   POINTER VALUE;
END-PR;

//  Test Bit in String (TSTBTS)
DCL-PR tstbts INT(10) EXTPROC('tstbts');
  bit_string POINTER VALUE;
  bit_offset INT(10) VALUE;
END-PR;

//  getenv()--Get Value of Environment Variable
DCL-PR getenv POINTER EXTPROC('getenv');
  name POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  putenv()--Change or Add Environment Variable
DCL-PR putenv INT(10) EXTPROC('putenv');
  string POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  Qp0zDltEnv()--Delete an Environment Variable
DCL-PR Qp0zDltEnv INT(10) EXTPROC('Qp0zDltEnv');
  name POINTER OPTIONS(*STRING) VALUE;
END-PR;

//  Qp0zInitEnv()--Initialize Environment for Variables
DCL-PR Qp0zInitEnv INT(10) EXTPROC('Qp0zInitEnv');
END-PR;

DCL-S ENVIRON POINTER IMPORT('environ');

//  Generate Universal Unique Identifier (GENUUID)
DCL-PR genUUID EXTPROC('_GENUUID');
  uuid_template POINTER VALUE;
END-PR;

DCL-DS uuid_template_t QUALIFIED BASED(pDummy);
  bytPrv   UNS(10);
  bytAvl   UNS(10);
  reserved CHAR(8);
  uuid     CHAR(16);
END-DS;

//  Convert Hex to Character (CVTHC)
DCL-PR cvthc EXTPROC('cvthc');
  pResult    POINTER VALUE;
  pSource    POINTER VALUE;
  sourceSize INT(10) VALUE;
END-PR;

//  Convert Eight Bit Character to Hex Nibbles (CVTCH)
DCL-PR cvtch EXTPROC('cvtch');
  pResult   POINTER VALUE;
  pSource   POINTER VALUE;
  sourceLen INT(10) VALUE;
END-PR;

//  Cipher (CIPHER)
DCL-PR cipher EXTPROC('_CIPHER');
  *N POINTER CONST;
  *N POINTER VALUE;
  *N POINTER CONST;
END-PR;

DCL-DS cipherCtrls_t QUALIFIED BASED(pDummy) ALIGN;
  function      CHAR(2) POS(1);
  hashAlg       CHAR(1) POS(3);
  sequence      CHAR(1) POS(4);
  dataLength    UNS(10) POS(5);
  output        CHAR(1) POS(9);
  reserved_1    CHAR(7) POS(10);
  hashContext   POINTER POS(17);
  HMACKey       POINTER POS(33);
  HMACKeyLength UNS(10) POS(49);
  reserved_2    CHAR(44) POS(53);
END-DS;

DCL-C cCIPHER_MD5 x'00';
DCL-C cCIPHER_SHA1 x'01';

DCL-C cCIPHER_ONLY x'00';
DCL-C cCIPHER_FIRST x'01';
DCL-C cCIPHER_MIDDLE x'02';
DCL-C cCIPHER_FINAL x'03';

DCL-C cCIPHER_HASH x'00';
DCL-C cCIPHER_HMAC x'01';

/ENDIF

