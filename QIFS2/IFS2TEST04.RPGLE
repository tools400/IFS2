     *===============================================================*                       RADDAT
     *  Test: ifsPath_*                                              *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST04) // using: '\home\raddatz\fileName.ext'*                       RADDAT
     *    CALL PGM(IFS2TEST04) PARM('\home\raddatz\fileName.ext')    *                       RADDAT
     *===============================================================*                       RADDAT
     *   >>PRE-COMPILER<<                                            *                       RADDAT
     *                                                               *                       RADDAT
     *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *                       RADDAT
     *                              SRCFILE(&SL/&SF) +               *                       RADDAT
     *                              SRCMBR(&SM);                     *                       RADDAT
     *                                                               *                       RADDAT
     *     >>COMPILE<<                                               *                       RADDAT
     *       >>PARM<< TRUNCNBR(*NO);                                 *                       RADDAT
     *       >>PARM<< DBGVIEW(*LIST);                                *                       RADDAT
     *       >>PARM<< TGTRLS(*CURRENT);                              *                       RADDAT
     *     >>END-COMPILE<<                                           *                       RADDAT
     *                                                               *                       RADDAT
     *     >>EXECUTE<<                                               *                       RADDAT
     *                                                               *                       RADDAT
     *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *                       RADDAT
     *                              MODULE(&LI/&OB) +                *                       RADDAT
     *                              ACTGRP(*NEW) +                   *                       RADDAT
     *                              BNDSRVPGM(&LI/IFS2     +         *                       RADDAT
     *                                        &LI/BASICS1) +         *                       RADDAT
     *                              BNDDIR(QC2LE         ) +         *                       RADDAT
     *                              TGTRLS(*CURRENT) +               *
     *                              DETAIL(*BASIC);                  *                       RADDAT
     *                                                               *                       RADDAT
     *   >>END-PRE-COMPILER<<                                        *                       RADDAT
     *===============================================================*                       RADDAT
     H DEBUG                                                                                  RADDAT
     H OPTION(*SRCSTMT : *NODEBUGIO)                                                          RADDAT
     H DECEDIT('0,') DATEDIT(*DMY.)                                                           RADDAT
     H DATFMT(*ISO )  TIMFMT(*ISO )                                                           RADDAT
     H EXPROPTS(*RESDECPOS)                                                                   RADDAT
     H EXTBININT(*YES)                                                                        RADDAT
     *===============================================================*                       RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type Definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  External Prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,PIFS2                                                                      RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global Fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global Constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Prototypes                                                                           RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QBASICS1,PBASICS1                    
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                         extpgm('IFS2TEST04')                        RADDAT
     D  gi_path                      32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     D  i_path                             value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Sends a message to QCMD                                                              RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PR                                                                     RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Program Entry Point                                                                  RADDAT
     *===============================================================*                       RADDAT
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PI                                                                     RADDAT
     D  gi_path                      32A   const  options(*nopass)                            RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (%parms() >= 1);                                                                //RADDAT
            main(gi_path);                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            main('\home\raddatz\fileName.ext');                                             //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         *inlr = *on;                                                                       //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  *** private ***                                                                      RADDAT
     *  Sends a message to the caller.                                                       RADDAT
     *===============================================================*                       RADDAT
    P sndMsg...                                                                              RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D sndMsg...                                                                              RADDAT
     D                 PI                                                                     RADDAT
     D  i_text                      128A   value  varying                                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D pBuffer         S               *   inz                                                RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D msgKey          S              4A                        inz                           RADDAT
     *                                                                                       RADDAT
     D qMsgF           DS                  qualified            inz                           RADDAT
     D  name                         10A                                                      RADDAT
     D  lib                          10A                                                      RADDAT
     *                                                                                       RADDAT
     D errCode         DS                  qualified            inz                           RADDAT
     D  bytPrv                       10I 0                                                    RADDAT
     D  bytAvl                       10I 0                                                    RADDAT
     D  excID                         7A                                                      RADDAT
     D  reserved                      1A                                                      RADDAT
     D  excDta                      256A                                                      RADDAT
     *                                                                                       RADDAT
     *  Send Program Message (QMHSNDPM) API                                                  RADDAT
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')                          RADDAT
     D   i_msgID                      7A   const                                              RADDAT
     D   i_qMsgF                     20A   const                                              RADDAT
     D   i_msgData                32767A   const  options(*varsize )                          RADDAT
     D   i_length                    10I 0 const                                              RADDAT
     D   i_msgType                   10A   const                                              RADDAT
     D   i_callStkE               32767A   const  options(*varsize )                          RADDAT
     D   i_callStkC                  10I 0 const                                              RADDAT
     D   o_msgKey                     4A                                                      RADDAT
     D   io_ErrCode               32767A          options(*varsize )                          RADDAT
     D   i_lenStkE                   10I 0 const  options(*nopass  )                          RADDAT
     D   i_callStkEQ                 20A   const  options(*nopass  )                          RADDAT
     D   i_wait                      10I 0 const  options(*nopass  )                          RADDAT
     D   i_callStkEDT                10A   const  options(*nopass  )                          RADDAT
     D   i_ccsid                     10I 0 const  options(*nopass  )                          RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         clear qMsgF;                                                                       //RADDAT
         qMsgF.name = 'QCPFMSG';                                                            //RADDAT
         qMsgF.lib  = '*LIBL';                                                              //RADDAT
                                                                                            //RADDAT
         clear errCode;                                                                     //RADDAT
         errCode.bytPrv = %size(errCode);                                                   //RADDAT
                                                                                            //RADDAT
         QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                  : '*CTLBDY': 1
                  : msgKey: errCode);                                                       //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P sndMsg...                                                                              RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Main procedure                                                                       RADDAT
     *===============================================================*                       RADDAT
    P main...                                                                                RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PI                                                                     RADDAT
     D  i_path                             value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D x               S             10I 0 inz                                                RADDAT
     D y               S             10I 0 inz                                                RADDAT
     D path            S                   like(ifs_path_t ) inz                              RADDAT
     D tmpPath         S                   like(ifs_path_t ) inz                              RADDAT
     D extension       S                   like(ifs_path_t ) inz                              RADDAT
     D extension1      S                   like(ifs_path_t ) inz                              RADDAT
     D extension2      S                   like(ifs_path_t ) inz                              RADDAT
     D path1           S                   like(ifs_path_t ) inz                              RADDAT
     D path2           S                   like(ifs_path_t ) inz                              RADDAT
     D file1           S                   like(ifs_path_t ) inz                              RADDAT
     D file2           S                   like(ifs_path_t ) inz                              RADDAT
     D directory1      S                   like(ifs_path_t ) inz                              RADDAT
     D directory2      S                   like(ifs_path_t ) inz                              RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         path = ifsPath_fixSyntax(%trimR(i_path));                                          //RADDAT
                                                                                            //RADDAT
         p_assert(%scan('\': path) = 0
                  : 'ifsPath_fixSyntax() did not convert ''\'' to ''/''');                  //RADDAT

         //Retrieve extension of passed in path
         x = f_scanR('.': path);
 B01     if (x > 0) and (x < %len(path));
            extension1 = %subst(path: x + 1);
            extension2 = ifsPath_getExtension(path);                                        //RADDAT
            p_assert(extension1 = extension2);
            sndMsg('Ext. of ' + f_addQuotes(path) + ' is: ' + extension2);                  //RADDAT
 E01     endif;

         //Remove extension from passed in path                                            //RADDAT
 B01     if (x > 1);
            path1 = %subst(path: 1: x - 1);
            path2 = ifsPath_removeExtension(path);                                          //RADDAT
            p_assert(path1 = path2);
            sndMsg('Path of ' + f_addQuotes(path) + ' is: ' + path2);                       //RADDAT
 E01     endif;
                                                                                            //RADDAT
         //Retrieve extensions                                                             //RADDAT
         extension = '.anExt';                                                              //RADDAT
                                                                                            //RADDAT
 B01     for y = %len(extension) + 2 downto 0;

            tmpPath = ifsPath_removeExtension(path) + extension;                            //RADDAT
            tmpPath = %subst(tmpPath: 1: %len(tmpPath) - y);                                //RADDAT

            x = f_scanR('.': tmpPath);                                                      //RADDAT
 B02        if (x > 0) and (x < %len(tmpPath));                                             //RADDAT
               extension1 = %subst(tmpPath: x + 1);                                         //RADDAT
 X02        else;
               extension1 = '';
 E02        endif;
            extension2 = ifsPath_getExtension(tmpPath);                                     //RADDAT
            p_assert(extension1 = extension2);
            sndMsg('Ext. of ' + f_addQuotes(tmpPath) + ' is: ' + extension2);               //RADDAT

 E01     endfor;
                                                                                            //RADDAT
         //Retrieve file name from path                                                    //RADDAT
         x = f_scanR('/': path);                                                            //RADDAT
 B01     if (x > 0) and (x < %len(path));                                                   //RADDAT
            file1 = %subst(path: x + 1);                                                    //RADDAT
            file2 = ifsPath_getName(path);                                                  //RADDAT
            p_assert(file1 = file2);                                                        //RADDAT
            sndMsg('File of ' + f_addQuotes(path) + ' is: ' + file2);                       //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Retrieve directory name from path                                               //RADDAT
         x = f_scanR('/': path);                                                            //RADDAT
 B01     if (x > 0) and (x <= %len(path));                                                  //RADDAT
            directory1 = f_left(path: x - 1);                                               //RADDAT
            directory2 = ifsPath_getDirectory(path);                                        //RADDAT
            p_assert(file1 = file2);                                                        //RADDAT
            sndMsg('Dir. of ' + f_addQuotes(path) + ' is: ' + directory2);                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
