**FREE
//===============================================================*
//  Test: Get/Set current working directory                      *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST05) // using: '\tmp'                      *
//    CALL PGM(IFS2TEST05) PARM('\home\raddatz\fileName.ext')    *
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
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST05');
  gi_directory CHAR(32) CONST OPTIONS(*NOPASS);
END-PR;
//
DCL-PR main;
  i_directory VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
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
  gi_directory CHAR(32) CONST OPTIONS(*NOPASS);
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 1);
  main(gi_directory);
else;
  main('\tmp');
endif;

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
//  Main procedure
//===============================================================*
DCL-PROC main;
  //
  DCL-PI *N;
    i_directory VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
  END-PI;
  //
  //  Helper fields
  DCL-S rc INT(10) INZ;
  DCL-S curDir LIKE(ifs_path_t) INZ;
  DCL-S tmpCurDir LIKE(ifs_path_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //Get current working directory
  curDir = ifsDirectory_getCurrent(msg);
  p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);
  p_assert(curDir<>'': 'Current working directory must not be *BLANKS');
  sndMsg('The current working directory is: ' + curDir);

  if (not ifsDirectory_exist(i_directory));
    sndMsg('Error: The specified directory ''' + i_directory +
            ''' does not exist.');
    return;
  endif;

  //Change current working directory to the specified directory
  rc = ifsDirectory_setCurrent(i_directory: msg);
  p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);
  p_assert(rc = cIFS_OK: 'Unexpected: rc=' + %char(rc));
  sndMsg('Current working directory changed to: ' + i_directory);

  //Verify current working directory
  tmpCurDir = ifsDirectory_getCurrent(msg);
  p_assert(tmpCurDir = ifsDirectory_fixSyntax(i_directory)
           : 'Current working directory has not been changed');

  //Change current working directory back to its original value
  ifsDirectory_setCurrent(curDir);

  return;

//
END-PROC MAIN;
//
