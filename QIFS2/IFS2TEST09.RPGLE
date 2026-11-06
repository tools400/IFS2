**FREE
//===============================================================*
//  Test: ifsPath_move(... cIFS_MOVE_FILE_REPLACE)               *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST09)                                       *
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
//
// ------------------------------------
//  Type Definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
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
/COPY QBASICS1,PBASICS1 
//
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST06');
END-PR;
//
DCL-PR main;
END-PR;
//
//  Creates a temporary file.
DCL-PR createTempFile LIKE(ifs_path_t);
END-PR;
//
//  Sends a message to QCMD
DCL-PR sndMsg;
  i_text VARCHAR(128) VALUE;
END-PR;
//
//===============================================================*
//  Program Entry Point
//===============================================================*
//
DCL-PI PGM_ENTRY_POINT;
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;

//
//===============================================================*
//  *** private ***
//  Sends a message to the caller.
//===============================================================*
DCL-PROC sndMsg;
  //
  DCL-PI *N;
    i_text VARCHAR(128) VALUE;
  END-PI;
  //
  //  Return value
  DCL-S pBuffer POINTER INZ;
  //
  //  Local fields
  DCL-S msgKey CHAR(4) INZ;
  //
  DCL-DS qMsgF QUALIFIED INZ;
    name CHAR(10);
    lib  CHAR(10);
  END-DS;
  //
  DCL-DS errCode QUALIFIED INZ;
    bytPrv   INT(10);
    bytAvl   INT(10);
    excID    CHAR(7);
    reserved CHAR(1);
    excDta   CHAR(256);
  END-DS;
  //
  //  Send Program Message (QMHSNDPM) API
  DCL-PR QMHSNDPM EXTPGM('QMHSNDPM');
    i_msgID      CHAR(7) CONST;
    i_qMsgF      CHAR(20) CONST;
    i_msgData    CHAR(32767) CONST OPTIONS(*VARSIZE);
    i_length     INT(10) CONST;
    i_msgType    CHAR(10) CONST;
    i_callStkE   CHAR(32767) CONST OPTIONS(*VARSIZE);
    i_callStkC   INT(10) CONST;
    o_msgKey     CHAR(4);
    io_ErrCode   CHAR(32767) OPTIONS(*VARSIZE);
    i_lenStkE    INT(10) CONST OPTIONS(*NOPASS);
    i_callStkEQ  CHAR(20) CONST OPTIONS(*NOPASS);
    i_wait       INT(10) CONST OPTIONS(*NOPASS);
    i_callStkEDT CHAR(10) CONST OPTIONS(*NOPASS);
    i_ccsid      INT(10) CONST OPTIONS(*NOPASS);
  END-PR;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear qMsgF;
  qMsgF.name = 'QCPFMSG';
  qMsgF.lib  = '*LIBL';

  clear errCode;
  errCode.bytPrv = %size(errCode);

  QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
           : '*CTLBDY': 1
           : msgKey: errCode);

  return;

//
END-PROC;
//
//===============================================================*
//  Creates a temporary file.
//===============================================================*
DCL-PROC createTempFile;
  //
  DCL-PI *N LIKE(ifs_path_t);
  END-PI;
  //
  //  Return value
  DCL-S fileName LIKE(ifs_path_t) INZ;
  //
  //  Helper fields
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //Create a temporary file
  fileName = ifsFile_getTempPath();
  fileName = ifsPath_getDirectory(fileName) +
             'ifs2_' + ifsPath_getName(fileName);
  hFile = ifsFile_open(fileName
                       : O_RDONLY + O_SHARE_RDONLY +
                         O_CREAT + O_EXCL + O_TEXTDATA
                       : *omit: *omit: *omit);
  ifsFile_close(hFile);

  return fileName;

//
END-PROC;
//
//===============================================================*
//  Main procedure
//===============================================================*
DCL-PROC main;
  //
  DCL-PI *N;
  END-PI;
  //
  //  Helper fields
  DCL-S tmpRC INT(10) INZ;
  DCL-S fileNameTemp LIKE(ifs_path_t) INZ;
  DCL-S fileNameRoot LIKE(ifs_path_t) INZ;
  DCL-S fileNameRnmd LIKE(ifs_path_t) INZ;
  DCL-S crtTimeTemp TIMESTAMP INZ;
  DCL-S crtTimeRoot TIMESTAMP INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //Create a temporary file
  fileNameTemp = createTempFile();
  fileNameRoot = '/' + ifsPath_getName(filenameTemp);
  fileNameRnmd = fileNameTemp + '.renamed';

  //Copy it to the root directory
  p_wait(1);  //Ensure different timestamps

  tmpRC = ifsFile_copy(fileNameTemp: '/': cIFS_COPY_FILE_DFT: *omit: msg);
  p_assert(tmpRC = cIFS_OK
           : 'Expected cIFS_OK from ifsFile_copy()');
  p_assert(msg.ID = cMSG_ID_OK
           : 'Expected cMSG_ID_OK from ifsFile_copy()');

  //Get creation timestamps
  crtTimeTemp = ifsFile_getCreationTime(fileNameTemp);
  crtTimeRoot = ifsFile_getCreationTime('/' + fileNameTemp);

  //Try to move it to the root directory --> ERROR
  tmpRC = ifsFile_move(fileNameTemp: '/': cIFS_MOVE_FILE_DFT: msg);
  p_assert(tmpRC = cIFS_ERROR
           : 'Expected cIFS_ERROR from ifsFile_move()');
  p_assert(msg.ID = 'IFS1003'
           : 'Expected ''IFS1003'' from ifsFile_move()');

  //Now move it to the root, replacing the existing file
  tmpRC = ifsFile_move(fileNameTemp: '/': cIFS_MOVE_FILE_REPLACE: msg);
  p_assert(tmpRC = cIFS_OK
           : 'Expected cIFS_OK from ifsFile_move()');
  p_assert(msg.ID = cMSG_ID_OK
           : 'Expected cMSG_ID_OK from ifsFile_move()');

  //Check that file has been moved.
  p_assert(not ifsFile_exist(fileNameTemp)
           : 'Expected temp. file moved to root');
  p_assert(crtTimeTemp = ifsFile_getCreationTime(fileNameRoot)
           : 'Expected the root file to have the creation timestamp +
              of the temp. file, because it was moved');

  //Move it back to where it came from, rename it --> ERROR
  tmpRC = ifsFile_move(fileNameRoot: fileNameRnmd: *omit: msg);
  p_assert(tmpRC = cIFS_ERROR
           : 'Expected cIFS_ERROR from ifsFile_move()');
  p_assert(msg.ID = 'IFS1047'
           : 'Expected ''IFS1047'' from ifsFile_move()');

  //Move it back to where it came from, rename it
  tmpRC = ifsFile_move(fileNameRoot: fileNameRnmd
                       : cIFS_MOVE_FILE_ALLOW_RENAME: msg);
  p_assert(tmpRC = cIFS_OK
           : 'Expected cIFS_OK from ifsFile_move()');
  p_assert(msg.ID = cMSG_ID_OK
           : 'Expected cMSG_ID_OK from ifsFile_move()');

  //Remove temorary file
  ifsFile_delete(fileNameRnmd);

  //Remove file from root directory
  //ifsFile_delete(fileNameRoot);




  return;

//
END-PROC MAIN;
//
