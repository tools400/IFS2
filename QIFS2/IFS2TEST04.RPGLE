**FREE
//===============================================================*
//  Test: ifsPath_*                                              *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST04) // using: '\home\raddatz\fileName.ext'*
//    CALL PGM(IFS2TEST04) PARM('\home\raddatz\fileName.ext')    *
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
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST04');
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
  main('\home\raddatz\fileName.ext');
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
  DCL-S y INT(10) INZ;
  DCL-S path LIKE(ifs_path_t) INZ;
  DCL-S tmpPath LIKE(ifs_path_t) INZ;
  DCL-S extension LIKE(ifs_path_t) INZ;
  DCL-S extension1 LIKE(ifs_path_t) INZ;
  DCL-S extension2 LIKE(ifs_path_t) INZ;
  DCL-S path1 LIKE(ifs_path_t) INZ;
  DCL-S path2 LIKE(ifs_path_t) INZ;
  DCL-S file1 LIKE(ifs_path_t) INZ;
  DCL-S file2 LIKE(ifs_path_t) INZ;
  DCL-S directory1 LIKE(ifs_path_t) INZ;
  DCL-S directory2 LIKE(ifs_path_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  path = ifsPath_fixSyntax(%trimR(i_path));

  p_assert(%scan('\': path) = 0
           : 'ifsPath_fixSyntax() did not convert ''\'' to ''/''');

  //Retrieve extension of passed in path
  x = f_scanR('.': path);
  if (x > 0) and (x < %len(path));
    extension1 = %subst(path: x + 1);
    extension2 = ifsPath_getExtension(path);
    p_assert(extension1 = extension2);
    sndMsg('Ext. of ' + f_addQuotes(path) + ' is: ' + extension2);
  endif;

  //Remove extension from passed in path
  if (x > 1);
    path1 = %subst(path: 1: x - 1);
    path2 = ifsPath_removeExtension(path);
    p_assert(path1 = path2);
    sndMsg('Path of ' + f_addQuotes(path) + ' is: ' + path2);
  endif;

  //Retrieve extensions
  extension = '.anExt';

  for y = %len(extension) + 2 downto 0;

    tmpPath = ifsPath_removeExtension(path) + extension;
    tmpPath = %subst(tmpPath: 1: %len(tmpPath) - y);

    x = f_scanR('.': tmpPath);
    if (x > 0) and (x < %len(tmpPath));
      extension1 = %subst(tmpPath: x + 1);
    else;
      extension1 = '';
    endif;
    extension2 = ifsPath_getExtension(tmpPath);
    p_assert(extension1 = extension2);
    sndMsg('Ext. of ' + f_addQuotes(tmpPath) + ' is: ' + extension2);

  endfor;

  //Retrieve file name from path
  x = f_scanR('/': path);
  if (x > 0) and (x < %len(path));
    file1 = %subst(path: x + 1);
    file2 = ifsPath_getName(path);
    p_assert(file1 = file2);
    sndMsg('File of ' + f_addQuotes(path) + ' is: ' + file2);
  endif;

  //Retrieve directory name from path
  x = f_scanR('/': path);
  if (x > 0) and (x <= %len(path));
    directory1 = f_left(path: x - 1);
    directory2 = ifsPath_getDirectory(path);
    p_assert(file1 = file2);
    sndMsg('Dir. of ' + f_addQuotes(path) + ' is: ' + directory2);
  endif;

  return;

//
END-PROC MAIN;
//
