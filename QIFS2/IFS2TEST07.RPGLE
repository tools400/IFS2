**FREE
//===============================================================*
//  Test: ifsPath_getName()                                      *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST07)                                       *
//    CALL PGM(IFS2TEST07) PARM('\home\raddatz\fileName.ext')    *
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
  gi_path CHAR(32) CONST OPTIONS(*NOPASS);
END-PR;
//
DCL-PR main;
  i_path VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
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
  gi_path CHAR(32) CONST OPTIONS(*NOPASS);
END-PI;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 1);
  main(gi_path);
else;
  main('nameOnly.txt');
  main('/directoryWithFile/aFile.txt');
  main('/directoryOnly/');
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
    i_path VALUE LIKE(ifs_path_t) OPTIONS(*TRIM);
  END-PI;
  //
  //  Helper fields
  DCL-S x INT(10) INZ;
  DCL-S isDirectory IND INZ(cFalse);
  DCL-S isNameOnly IND INZ(cFalse);
  DCL-S directory LIKE(ifs_path_t) INZ;
  DCL-S name LIKE(ifs_path_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (f_endsWith('/': i_path) or f_endsWith('\': i_path));
    isDirectory = cTrue;
  else;
    isDirectory = cFalse;
  endif;

  x = %scan('/': i_path) + %scan('\': i_path);
  if (x = 0);
    isNameOnly = cTrue;
  else;
    isNameOnly = cFalse;
  endif;

  name = ifsPath_getName(i_path);
  if (isDirectory);
    p_assert(name = ''
             : 'Expected ''name'' to be empty for DIRECTORIES');
  else;
    p_assert(name <> ''
             : 'Expected ''name'' not to be empty for FILES');
  endif;

  directory = ifsPath_getDirectory(i_path);
  if (isNameOnly);
    p_assert(directory = ''
             : 'Expected ''directory'' to be empty +
               if ''i_path'' is NAME_ONLY');
  else;
    p_assert(directory <> ''
             : 'Expected ''directory'' not to be empty +
               if ''i_path'' is not NAME_ONLY');
  endif;


  name = ifsPath_getName('/home/raddatz/directoryOnly/': cTrue);
  p_assert(name = 'directoryOnly/'
           : 'Unexpected value for ''i_derectory = cTrue''');

  return;

//
END-PROC MAIN;
//
