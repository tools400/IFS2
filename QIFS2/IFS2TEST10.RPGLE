     *===============================================================*                       RADDAT
     *  Test: ifsDirectory_read()                                    *                       RADDAT
     *---------------------------------------------------------------*                       RADDAT
     *    CALL PGM(IFS2TEST10) // using the current directory        *                       RADDAT
     *    CALL PGM(IFS2TEST10) PARM('/home/raddatz/test_ifs/*')      *                       RADDAT
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
     *                              TGTRLS(*CURRENT) +               *                       RADDAT
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
     FQSYSPRT   O    F  132        PRINTER oflind(*INOF)                                      RADDAT
     F                                     usropn                                             RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type Definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     D resultSet_t     DS                  based(pDummy)   qualified                          RADDAT
     D  selectedPath                       like(ifs_path_t)
     D  msg                                likeds(msg_t   )
     D  numE                         10I 0                                                    RADDAT
     D  entry                              likeds(entry_t) dim(10)
     *                                                                                       RADDAT
     D entry_t         DS                  based(pDummy)   qualified                          RADDAT
     D  type                               like(ifs_type_t)
     D  path                               like(ifs_path_t)
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  External Prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,CLIB                                                                       RADDAT
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
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PR                         extpgm('IFS2TEST10')                        RADDAT
     D  gi_dir                       32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D main...                                                                                RADDAT
     D                 PR                                                                     RADDAT
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Prints a line                                                                        RADDAT
     D print...                                                                               RADDAT
     D                 PR                                                                     RADDAT
     D  i_line                             value  like(g_PrintLine)                           RADDAT
     *                                                                                       RADDAT
     *  Program status data structure                                                        RADDAT
     D sds            SDS                  qualified                                          RADDAT
     D  pgmLib                81     90A                                                      RADDAT
     D  pgmContProc          334    343A                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Program Entry Point                                                                  RADDAT
     *===============================================================*                       RADDAT
     *                                                                                       RADDAT
     D PGM_ENTRY_POINT...                                                                     RADDAT
     D                 PI                                                                     RADDAT
     D  gi_dir                       32A   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     D g_dir           S                   like(ifs_path_t ) inz                              RADDAT
     D g_PrintLine     S            132A                     inz                              RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (%parms() >= 1);                                                                //RADDAT
            main(gi_dir);                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            g_dir = ifsDirectory_getCurrent();                                              //RADDAT
            main(g_dir);                                                                    //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         *inlr = *on;                                                                       //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Printer output                                                                       RADDAT
     *===============================================================*                       RADDAT
     OQSYSPRT   E                                                                             RADDAT
     O                       g_PrintLine        132A                                          RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Prints a line.                                                                       RADDAT
     *===============================================================*                       RADDAT
    P print...                                                                               RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D print...                                                                               RADDAT
     D                 PI                                                                     RADDAT
     D  i_line                             value  like(g_PrintLine)                           RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         g_PrintLine = i_line;                                                              //RADDAT
         except;                                                                            //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P print...                                                                               RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *===============================================================*                       RADDAT
     *  Callback to process directory entries.                                               RADDAT
     *===============================================================*                       RADDAT
    P ifsDirectory_read_Dirent...                                                            RADDAT
    P                 B                                                                      RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_read_Dirent...                                                            RADDAT
     D                 PI              N                                                      RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t )                           RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_dirent                           const  likeds(dirent_t )                           RADDAT
     D  i_type                             const  like(ifs_type_t )                           RADDAT
     D  i_pUserData                    *   const                                              RADDAT
     D  o_msg                                     likeds(msg_t    )                           RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D  name           S                   like(i_dirent.d_name   ) inz                       RADDAT
     D  path           S                   like(ifs_path_t        ) inz                       RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         name = f_left(i_dirent.d_name: i_dirent.d_namelen);                                //RADDAT
         path = i_directory + name;                                                         //RADDAT
                                                                                            //RADDAT
         print(f_space(2 * i_level) + '[' + %trim(i_type) + '] ' + path +
               ' (x''' + ifsFile_getID(path) + ''')');                                      //RADDAT
                                                                                            //RADDAT
                                                                                            //RADDAT
         return cIFS_CONTINUE;                                                              //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsDirectory_read_Dirent...                                                            RADDAT
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
     D  i_dir                              value  like(ifs_path_t )                           RADDAT
     D                                            options(*trim)                              RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D rc              S             10I 0 inz                                                RADDAT
     D homeDir         S                   like(ifs_path_t   ) inz                            RADDAT
     D msg             DS                  likeds(msg_t      ) inz                            RADDAT
     * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE

         //-----------------------------------------------------
         //  Search for 'Hello' in all 'log' files of a                                    //RADDAT
         //  given directory structure                                                     //RADDAT
         //-----------------------------------------------------
         open QSYSPRT;                                                                      //RADDAT
                                                                                            //RADDAT
         homeDir = i_dir;                                                                   //RADDAT
                                                                                            //RADDAT
         rc = ifsDirectory_read(homeDir + '*.txt'
                                : %paddr('ifsDirectory_read_Dirent')
                                : cIFS_READDIR_CB_DIRENT
                                  + cIFS_READDIR_DIRECTORY
                                  + cIFS_READDIR_FILE
                                  + cIFS_READDIR_SUBDIRECTORY
                                : *NULL
                                : msg);                                                     //RADDAT
         p_assert(rc > 0: 'Unexpected: rc=' + %char(rc));                                   //RADDAT
         p_assert(msg.ID = cMSG_ID_OK: 'Unexpected: msg.ID=' + msg.ID);                     //RADDAT
                                                                                            //RADDAT
         close QSYSPRT;                                                                     //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P main...                                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
