**FREE
//===============================================================*
//  Test: Create / Read / Remove temp. directory tree            *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST03) // using a temp. directory in '/tmp'  *
//    CALL PGM(IFS2TEST03) PARM('/home/raddatz/test_ifs/*')      *
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
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST03');
  gi_dir CHAR(32) CONST OPTIONS(*NOPASS);
END-PR;
//
DCL-PR main;
  i_dir VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
END-PR;
//
//  Creates some files in a given directory.
DCL-PR createFiles;
  i_dir   VALUE LIKE(ifs_path_t);
  i_level INT(10) VALUE;
END-PR;
//
//  Prints a line
DCL-PR print;
  i_line VALUE LIKE(g_PrintLine);
END-PR;
//
//  Produces a directory tree including files and subdirectories.
DCL-PR createDirectoryTree;
  i_dir     VALUE LIKE(ifs_path_t);
  i_level   INT(10) VALUE;
  i_options INT(10) VALUE;
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
  g_dir = ifsFile_getTempPath();
  g_dir = ifsPath_getDirectory(g_dir) +
          'ifs2_' + ifsPath_getName(g_dir);
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
//  Creates some files in a given directory.
//===============================================================*
DCL-PROC createFiles;
  //
  DCL-PI *N;
    i_dir   VALUE LIKE(ifs_path_t);
    i_level INT(10) VALUE;
  END-PI;
  //
  //  Helper fields
  DCL-S rc INT(10) INZ;
  DCL-S numFiles INT(10) INZ;
  DCL-S file LIKE(ifs_path_t) INZ;
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  DCL-C FILES_MAX 10;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  numFiles = %int(FILES_MAX / RAND_MAX * rand());

  dow (numFiles > 0);

    file = i_dir + 'ifs2_tmpFile_' + %char(i_level ) + '_'
                                   + %char(numFiles) + '.txt';
    hFile = ifsFile_open(file
                         : O_RDWR + O_SHARE_RDONLY +
                           O_CREAT + O_EXCL + O_CCSID + O_TEXTDATA
                         : 1252
                         : S_IRWXU + S_IRWXG + S_IRWXO
                         : msg);
    p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);

    ifsFile_writeLine(hFile
          : 'This is a test file create by the IFS2 utility.': 0);
    ifsFile_writeLine(hFile
          : 'It has been created by program: ' +
             f_objName(sds.pgmContProc: sds.pgmLib): 0);

    rc = ifsFile_close(hFile: msg);
    p_assert(rc = cIFS_OK: 'Unexpected: rc=' + %char(rc));
    p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);

    numFiles = numFiles - 1;
  enddo;

  p_assert(file  = '' and ifsDirectory_isEmpty(i_dir) or
           file <> '' and not ifsDirectory_isEmpty(i_dir));

  return;

//
END-PROC;
//
//===============================================================*
//  Produces a directory tree including files and subdirectories.
//===============================================================*
DCL-PROC createDirectoryTree;
  //
  DCL-PI *N;
    i_dir     VALUE LIKE(ifs_path_t);
    i_level   INT(10) VALUE;
    i_options INT(10) VALUE;
  END-PI;
  //
  //  Helper fields
  DCL-S rc INT(10) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_level > 3);
    return;
  endif;

  rc = ifsDirectory_create(i_dir: i_options: *omit: msg);

  p_assert(rc = cIFS_OK: 'Unexpected: rc=' + %char(rc));
  p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);

  createFiles(i_dir: i_level);

  createDirectoryTree(i_dir + 'subDirectory_' + %char(i_level + 1) + '/'
                      : i_level + 1
                      : cIFS_MKDIR_DFT);

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
  DCL-S path LIKE(ifs_path_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  path = i_directory + f_left(i_dirent.d_name: i_dirent.d_namelen);

  print(f_space(2 * i_level) + '[' + %trim(i_type) + '] ' + path +
        ' (x''' + ifsFile_getID(path) + ''')');


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
  DCL-S rc1 INT(10) INZ;
  DCL-S rc2 INT(10) INZ;
  DCL-S homeDir LIKE(ifs_path_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //-----------------------------------------------------
  //  Initialize pseudo random number generator
  //-----------------------------------------------------
  srand(time(*NULL));

  //-----------------------------------------------------
  //  Produce a directory tree
  //-----------------------------------------------------
  i_dir = ifsDirectory_fixSyntax(i_dir);

  if (ifsDirectory_exist(i_dir));
    i_dir = f_left(i_dir: %len(i_dir)-1);
    homeDir = i_dir + ifsFile_getTempPath() + '/';
    createDirectoryTree(homeDir: 1: cIFS_MKDIR_SUBDIR);
  else;
    homeDir = i_dir;
    createDirectoryTree(homeDir: 1: cIFS_MKDIR_DFT);
  endif;


  //-----------------------------------------------------
  //  Print directory structure
  //-----------------------------------------------------
  open QSYSPRT;

  if (f_endsWith('/': homeDir));                    //Remove trailing SLASH
    homeDir = f_left(homeDir: %len(homeDir) - 1);  //to read the higher directory
  endif;                                            //using the directory we just
  //created as the pattern.       //RADDAT
  rc1 = ifsDirectory_read(homeDir
                          : %paddr('ifsDirectory_read_Dirent')
                          : cIFS_READDIR_CB_DIRENT
                            + cIFS_READDIR_DIRECTORY
                            + cIFS_READDIR_FILE
                            + cIFS_READDIR_SUBDIRECTORY
                          : *NULL
                          : msg);
  p_assert(rc1 > 0: 'Unexpected: rc1=' + %char(rc1));
  p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);

  close QSYSPRT;

  //-----------------------------------------------------
  //  Rename directory structure
  //-----------------------------------------------------
  rc = ifsDirectory_rename(homeDir
                           : ifsPath_getName(homeDir) + '.renamed'
                           : msg);
  p_assert(rc = cIFS_OK
           : 'Expected cIFS_OK from ifsDirectory_rename()');
  p_assert(msg.ID = cMSG_ID_OK
           : 'Expected msg ID cMSG_ID_OK when renaming an +
              existing directory');

  //-----------------------------------------------------
  //  Delete directory structure
  //-----------------------------------------------------
  rc2 = ifsDirectory_remove(homeDir + '.renamed'
                            : cIFS_RMDIR_DELETE_SUB_DIRECTORIES: msg);
  p_assert(rc2 > 0: 'Unexpected: rc2=' + %char(rc2));
  p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);
  p_assert(rc1 = rc2: 'Number of created entries does not match +
                       number of deleted entries: ' +
                       %char(rc1) + '/' + %char(rc2));

  return;

//
END-PROC MAIN;
//
