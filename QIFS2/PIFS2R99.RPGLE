**FREE
/IF NOT DEFINED(PIFS2R99)
/DEFINE PIFS2R99
//
// --------------------------------
//  Imported prototypes
// --------------------------------
/COPY QIFS2,PIFS2  Stream File and Directory
/COPY QIFS2,CLIB  C Runtime Library
//
// --------------------------------
//  Exported procedures
// --------------------------------
//
//  Returns cTrue, if a given file information structure belongs to a
//  symbolic link.
DCL-PR STAT_isSymbolicLink IND EXTPROC('IFS2R99_STAT_isSymbolicLink');
  i_st_stat VALUE LIKEDS(st_stat_t);
END-PR;
//
//  Returns cTrue, if a given file information structure belongs to a
//  directory.
DCL-PR STAT_isDirectory IND EXTPROC('IFS2R99_STAT_isDirectory');
  i_st_stat VALUE LIKEDS(st_stat_t);
END-PR;
//
//  Returns cTrue, if a given file information structure belongs to a
//  file.
DCL-PR STAT_isFile IND EXTPROC('IFS2R99_STAT_isFile');
  i_st_stat VALUE LIKEDS(st_stat_t);
END-PR;
//
//  Produces a new 'Qlg_Path_Name_t' structure.
DCL-PR QLG_PATH_new LIKEDS(Qlg_Path_Name_t) EXTPROC('IFS2R99_QLG_PATH_new');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given file name matches a given pattern.
DCL-PR File_matchesPattern IND EXTPROC('IFS2R99_File_matchesPattern');
  i_file    CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_pattern CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Retrieves a file attribute of type: time
DCL-PR FileAttr_getTime INT(10) EXTPROC('IFS2R99_FileAttr_getTime');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_attr INT(10) CONST;
  o_time TIMESTAMP;
END-PR;
//
//  Converts a timestamp from Epoch to RPG format.
DCL-PR EpochTime_toTimestamp TIMESTAMP EXTPROC('IFS2R99_EpochTime_toTimestamp');
  i_epochTmStmp INT(10) VALUE;
END-PR;
//
//  Initializes code conversion.
DCL-PR Iconv_initialize LIKEDS(iconv_t) EXTPROC('IFS2R99_Iconv_initialize');
  i_fromCcsid UNS(10) VALUE;
  i_toCcsid   UNS(10) VALUE;
END-PR;
//
//  Terminatess code conversion.
DCL-PR Iconv_terminate EXTPROC('IFS2R99_Iconv_terminate');
  io_hIconv LIKEDS(iconv_t);
END-PR;
//
/ENDIF
