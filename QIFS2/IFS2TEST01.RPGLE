**FREE
//===============================================================*
//  Test: Create/Write/Read/Delete/Attr stream file              *
//---------------------------------------------------------------*
//    CALL PGM(IFS2TEST01) // using a temp. stream file          *
//    CALL PGM(IFS2TEST01) PARM('/home/raddatz/tmpFileName')     *
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
//                              BNDSRVPGM(&LI/IFS2       +       *
//                                        *LIBL/BASICS1) +       *
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
/COPY QIFS2,CEELIB  CEE APIs
/COPY QIFS2,PIFS2 
/COPY QBASICS1,PBASICS1 
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
DCL-PR PGM_ENTRY_POINT EXTPGM('IFS2TEST01');
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
//
DCL-S g_path LIKE(ifs_path_t) INZ;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 1);
  main(gi_path);
else;
  g_path = ifsFile_getTempPath();
  g_path = ifsPath_getDirectory(g_path) +
           'ifs2_' + ifsPath_getName(g_path);
  main(g_path);
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
  DCL-S rc INT(10) INZ;
  DCL-S path LIKE(ifs_path_t) INZ;
  DCL-S hFile LIKE(ifs_hFile_t) INZ;
  DCL-S bytesRead INT(10) INZ;
  DCL-S buffer CHAR(64) INZ;
  DCL-S size1 INT(10) INZ;
  DCL-S size2 INT(10) INZ;
  DCL-S crtTime TIMESTAMP INZ;
  DCL-S chgTime1 TIMESTAMP INZ;
  DCL-S chgTime2 TIMESTAMP INZ;
  DCL-S fileID1 LIKE(ifs_uniqueFileID_t) INZ;
  DCL-S fileID2 LIKE(ifs_uniqueFileID_t) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  path = ifsPath_fixSyntax(%trimR(i_path));

  dou '1';

    if (ifsFile_exist(path));
      sndMsg('ERROR: File ' + path + ' already exists');
      return;
    endif;

    //Open IFS file (using a bad name)
    hFile = ifsFile_open('   /tmp/badName.file'
                         : O_RDWR + O_SHARE_RDONLY +
                           O_CREAT + O_EXCL + O_TEXTDATA
                         : *omit
                         : *omit
                         : msg);

    p_assert(msg.ID = 'IFS1000'
             : 'Expected msg ID IFS1000 when using a bad name');

    //Open IFS file (The file must not yet exists!)
    //Open flags:     read & write
    //                share with readers
    //                create file, send message if file exists
    //                open for text data
    hFile = ifsFile_open(path
                         : O_RDWR + O_SHARE_RDONLY +
                           O_CREAT + O_EXCL + O_TEXTDATA
                         : *omit
                         : *omit
                         : msg);

    //Get file creation time
    crtTime = ifsFile_getCreationTime(path);
    p_assert(crtTime <> *LOVAL
             : 'Expected the file to have a creation time');

    //Get file last changed time
    chgTime1 = ifsFile_getDataChangeTime(path);
    p_assert(chgTime1 <> *LOVAL
             : 'Expected to get a time the file data was last changed');
    p_assert(chgTime1 = crtTime
             : 'Expected chgTime1 to be equal to crtTime');

    //Wait a couple of seconds
    p_wait(3);

    //Write to file
    rc = ifsFile_write(hFile: 'Hello World!': 0);
    p_assert(rc = 12
             : 'Expected to write 12 byte to file');

    //Set read pointer to 'World!'
    rc = ifsFile_seek(hFile: 6: SEEK_SET);
    //   ^-----------------  Offset to 'World', starting at 0.
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_OK from ifsFile_seek()');

    //Read from file
    rc = ifsFile_read(hFile: %addr(buffer): %size(buffer));
    p_assert(rc = 6
             : 'Expected to read 6 byte from file');
    p_assert(buffer = 'World!'
             : 'Expected to read ''World!'' from file');

    //Get file size using the file descriptor
    size1 = ifsFile_getSizeH(hFile);
    p_assert(size1 = 12
             : 'Expected a size of 12 byte');

    //Get unique file ID using the file descriptor
    fileID1 = *ALLx'00';
    fileID1 = ifsFile_getUniqueIDH(hFile);
    p_assert(fileID1 <> *ALLx'00'
             : 'Expected fileID1 to be different from x''00''');

    //Close IFS file
    ifsFile_close(hFile);

    //Get file size
    size2 = ifsFile_getSize(path);
    p_assert(size2 = 12
             : 'Expected a size of 12 byte');
    p_assert(size1 = size2
             : 'Expected size1 to be equal to size2');

    //Get unique file ID
    fileID2 = *ALLx'00';
    fileID2 = ifsFile_getUniqueID(path);
    p_assert(fileID2 <> *ALLx'00'
             : 'Expected fileID2 to be different from x''00''');
    p_assert(fileID1 = fileID2
             : 'Expected fileID1 to be equal to fileID2');

    //Get file last changed time
    chgTime2 = ifsFile_getDataChangeTime(path);
    p_assert(chgTime2 <> *LOVAL
             : 'Expected to get a time the file data was last changed');
    p_assert(chgTime1 <> chgTime2
             : 'Expected chgTime1 to be different from chgTime2');

    //----------------------------------
    //  ifs_File_delete()
    //----------------------------------

    //Delete file using a bad name
    rc = ifsFile_delete(path + '.' + ifsFile_getTempPath(): msg);
    p_assert(rc = cIFS_ERROR
             : 'Expected cIFS_ERROR from ifsFile_delete()');
    p_assert(msg.ID = 'IFS1005'
             : 'Expected msg ID IFS1005 when using a bad name');

    //----------------------------------
    //  ifs_File_move()
    //----------------------------------

    //Move file to root '/' using a bad file name
    rc = ifsFile_move('  /badDirectory/badFileName': '/': *omit: msg);
    p_assert(rc = cIFS_ERROR
             : 'Expected cIFS_ERROR from ifsFile_move()');
    p_assert(msg.ID = 'IFS1012'
             : 'Expected msg ID IFS1012 when using a bad name');

    //Move file to root '/' using a bad directory name
    rc = ifsFile_move(path: '  /badDirName/': *omit: msg);
    p_assert(rc = cIFS_ERROR
             : 'Expected cIFS_ERROR from ifsFile_move()');
    p_assert(msg.ID = 'IFS1011'
             : 'Expected msg ID IFS1011 when using a bad name');

    //Move file to root '/'
    rc = ifsFile_move(path: '/': *omit: msg);
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_OK from ifsFile_move()');

    //Move file back to its original location
    rc = ifsFile_move('/' + ifsPath_getName(path)
                      : ifsPath_getDirectory(path): *omit: msg);
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_OK from ifsFile_move()');

    //----------------------------------
    //  ifs_File_rename()
    //----------------------------------

    //Rename file using a bad file name
    rc = ifsFile_rename(path + '.badFileName'
                        : ifsPath_getName(path) + '.txt': msg);
    p_assert(rc = cIFS_ERROR
             : 'Expected cIFS_ERROR from ifsFile_rename()');
    p_assert(msg.ID = 'IFS1012'
             : 'Expected msg ID IFS1012 when using a bad name');

    //Rename file, target contains directory
    rc = ifsFile_rename(path
                        : '/badDirectory' +
                          ifsPath_getName(path) + '.txt': msg);
    p_assert(rc = cIFS_ERROR
             : 'Expected cIFS_ERROR from ifsFile_rename()');
    p_assert(msg.ID = 'IFS1014'
             :'Expected msg ID IFS1014 when target contains directory');

    //Rename file, target exists
    rc = ifsFile_rename(path: ifsPath_getName(path): msg);
    p_assert(rc = cIFS_ERROR
             : 'Expected cIFS_ERROR from ifsFile_rename()');
    p_assert(msg.ID = 'IFS1013'
             :'Expected msg ID IFS1013 when target contains directory');

    //Rename file, to path + 'txt'
    rc = ifsFile_rename(path: ifsPath_getName(path) + '.txt': msg);
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_OK from ifsFile_rename()');

    //Rename it back to its original name
    rc = ifsFile_rename(path + '.txt': ifsPath_getName(path): msg);
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_OK from ifsFile_rename()');

  enddo;

  if (ifsFile_exist(path));
    rc = ifsFile_delete(path);
    p_assert(rc = cIFS_OK
             : 'Expected cIFS_ERROR from ifsFile_delete()');
  endif;

  return;

//
END-PROC MAIN;
//
