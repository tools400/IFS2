**FREE
//===============================================================*
//  Test: ifsDirectory_read()                                    *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST12) // using the current directory        *
//    CALL PGM(IFS2TEST12) PARM('/home/raddatz/test_ifs/*')      *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//       >>PARM<< OPTION(*EVENTF);                               *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/IFS2     +         *
//                                        &LI/BASICS1) +         *
//                              BNDDIR(QC2LE         ) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
CTL-OPT DEBUG OPTION(*SRCSTMT: *NODEBUGIO);
CTL-OPT DECEDIT('0,') DATEDIT(*DMY.);
CTL-OPT DATFMT(*ISO) TIMFMT(*ISO);
CTL-OPT EXPROPTS(*RESDECPOS);
CTL-OPT EXTBININT(*YES);
//===============================================================*
DCL-F QSYSPRT PRINTER(132) USAGE(*output) OFLIND(*INOF) USROPN;
//
// ------------------------------------
//  Type Definitions
// ------------------------------------
DCL-DS resultSet_t BASED(pDummy) QUALIFIED;
  selectedPath LIKE(ifs_path_t);
  msg          LIKEDS(msg_t);
  numE         INT(10);
  entry        LIKEDS(entry_t) DIM(10);
END-DS;
//
DCL-DS entry_t BASED(pDummy) QUALIFIED;
  type LIKE(ifs_type_t);
  path LIKE(ifs_path_t);
END-DS;
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QIFS2,CLIB 
/COPY QIFS2,PIFS2 
//
// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Global Constants
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------
//
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST12');
  gi_dir CHAR(32) CONST OPTIONS(*NOPASS);
END-PR;
//
DCL-PR main;
  i_dir VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
END-PR;
//
//  Prints a line
DCL-PR print;
  i_line VALUE LIKE(g_PrintLine);
END-PR;
//
//  Program status data structure
DCL-DS sds QUALIFIED PSDS;
  pgmLib      CHAR(10) POS(81);
  pgmContProc CHAR(10) POS(334);
END-DS;
//
//===============================================================*
//  Program Entry Point
//===============================================================*
//
DCL-PI PGM_ENTRY_POINT;
  gi_dir CHAR(32) CONST OPTIONS(*NOPASS);
END-PI;
//
DCL-S g_dir LIKE(ifs_path_t) INZ;
DCL-S g_PrintLine CHAR(132) INZ;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 1);
  main(gi_dir);
else;
  g_dir = ifsDirectory_getCurrent() + 'ifs2/';
  main(g_dir);
endif;

*inlr = *on;

return;

//
//===============================================================*
//  Prints a line.
//===============================================================*
DCL-PROC print;
  //
  DCL-PI *N;
    i_line VALUE LIKE(g_PrintLine);
  END-PI;
  //
  //  Local fields
  DCL-DS lineOutput LEN(132) INZ;
  END-DS;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  lineOutput = i_line;
  write QSYSPRT lineOutput;

  return;

//
END-PROC;
//
//===============================================================*
//  Callback to process directory entries.
//===============================================================*
DCL-PROC ifsDirectory_read_Dirent;
  //
  DCL-PI *N IND;
    i_level     INT(10) CONST;
    i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_dirent    CONST LIKEDS(dirent_t);
    i_type      CONST LIKE(ifs_type_t);
    i_pUserData POINTER CONST;
    o_msg       LIKEDS(msg_t);
  END-PI;
  //
  //  Helper fields
  DCL-S name LIKE(ifs_path_t) INZ;
  DCL-S path LIKE(ifs_path_t) INZ;
  //
  DCL-S isInit IND INZ(cFalse) STATIC;
  DCL-S tempFiles VARCHAR(256) DIM(10) BASED(i_puserData);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not isInit);
    ifsFile_delete(tempFiles(2));
  endif;

  name = f_left(i_dirent.d_name: i_dirent.d_namelen);
  path = i_directory + name;

  print(f_space(2 * i_level) + '[' + %trim(i_type) + '] ' + path +
        ' (x''' + ifsFile_getID(path) + ''')');

  ifsFile_delete(path);

  isInit = cTrue;

  return cIFS_CONTINUE;

//
END-PROC;
//
//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  //
  DCL-PI *N;
    i_dir VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
  END-PI;
  //
  //  Helper fields
  DCL-S rc INT(10) INZ;
  DCL-S homeDir LIKE(ifs_path_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  DCL-S x INT(10) INZ;
  DCL-S tempFiles VARCHAR(256) DIM(10) INZ;
  DCL-S fd LIKE(ifs_hFile_t) INZ;
  //
  DCL-C FILE_EXTENSION '.tmp';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open QSYSPRT;

  homeDir = i_dir;

  //-----------------------------------------------------
  //  Produce temporary files.
  //-----------------------------------------------------
  for x = 1 to %elem(tempFiles);
    tempFiles(x) =
          homeDir +
          ifsPath_getName(ifsFile_getTempPath()) + FILE_EXTENSION;
    fd = ifsFile_open(tempFiles(x): O_CREAT + O_EXCL + O_WRONLY);
    ifsFile_writeLine(fd: 'Test Serviceprogramm IFS': 0);
    ifsFile_close(fd);
  endfor;

  //-----------------------------------------------------
  //  Search for 'Hello' in all 'log' files of a
  //  given directory structure
  //-----------------------------------------------------
  rc = ifsDirectory_read(homeDir + '*' + FILE_EXTENSION
                         : %paddr('ifsDirectory_read_Dirent')
                         : cIFS_READDIR_CB_DIRENT
                           + cIFS_READDIR_FILE
                         : %addr(tempFiles)
                         : msg);
  p_assert(rc > 0: 'Unexpected: rc=' + %char(rc));
  p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);

  close QSYSPRT;

  return;

//
END-PROC MAIN;
//
