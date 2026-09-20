     *=====================================================================*                 RADDAT
     *  IFS2R03    - Tools/400: Stream File and Directory - Path           *                 RADDAT
     *=====================================================================*                 RADDAT
     *  Author  :  Thomas Raddatz                                          *                 RADDAT
     *  Date    :  03.02.2009                                              *                 RADDAT
     *  E-mail  :  thomas.raddatz@Tools400.de                              *                 RADDAT
     *  Homepage:  www.tools400.de                                         *                 RADDAT
     *=====================================================================*                 RADDAT
     *                                                                     *                 RADDAT
     *  This software is free software, you can redistribute it and/or     *                 RADDAT
     *  modify it under the terms of the GNU General Public License (GPL)  *                 RADDAT
     *  as published by the Free Software Foundation.                      *                 RADDAT
     *                                                                     *                 RADDAT
     *  See GNU General Public License for details.                        *                 RADDAT
     *          http://www.opensource.org                                  *                 RADDAT
     *          http://www.opensource.org/licenses/gpl-license.html        *                 RADDAT
     *                                                                     *                 RADDAT
     *=====================================================================*                 RADDAT
     *  History:                                                           *                 RADDAT
     *                                                                     *                 RADDAT
     *  Datum       Name          Änderung                                 *                 RADDAT
     *  ----------  ------------  ---------------------------------------  *                 RADDAT
     *                                                                     *                 RADDAT
     * =================================================================== *                 RADDAT
     * >>PRE-COMPILER<<                                                    *                 RADDAT
     *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *                 RADDAT
     *                           SRCFILE(&SL/&SF) +                        *                 RADDAT
     *                           SRCMBR(&SM);                              *                 RADDAT
     *                                                                     *                 RADDAT
     *   >>COMPILE<<                                                       *                 RADDAT
     *     >>PARM<< DBGVIEW(*LIST);                                        *                 RADDAT
     *     >>PARM<< TRUNCNBR(*NO );                                        *                 RADDAT
     *     >>PARM<< TGTRLS(V6R1M0);                                        *                 RADDAT
     *   >>END-COMPILE<<                                                   *                 RADDAT
     *                                                                     *                 RADDAT
     *   >>EXECUTE<<                                                       *                 RADDAT
     *                                                                     *                 RADDAT
     * >>END-PRE-COMPILER<<                                                *                 RADDAT
     * =================================================================== *                 RADDAT
     H NOMAIN                                                                                 RADDAT
CPY  /COPY QIFS2,H_SPEC                                                                     RADDAT
     * =================================================================== *                 RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Exported prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,PIFS2                                                                      RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Imported prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,CEELIB                          CEE APIs                                   RADDAT
CPY  /COPY QIFS2,PIFS2R04                        Stream File and Directory - App.Msg        RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Private prototypes                                                                   RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Type definitions                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QIFS2,TYPES                                                                      RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Retrieves the file name from a given path name.                                      RADDAT
     *=========================================================================              RADDAT
     *  Attention: The ifsPath_getName-function must also be able to                         RADDAT
     *             retrieve the file name from pathes starting with 'http://'                RADDAT
     *             or 'ftp://'. Please consider that, when changing the                      RADDAT
     *             ifsPath_getName-function.                                                 RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *   i_isDirectory - Must be set to cTrue if the name of the directory                   RADDAT
     *                   shall be retrieved from a path that specifies a                     RADDAT
     *                   directory, e.g.:    '/home/raddatz/tmp/'                            RADDAT
     *                   For that path the procedure returns the following                   RADDAT
     *                   values, depending on i_isDirectory:                                 RADDAT
     *                                 cTrue   ->  'tmp/'                                    RADDAT
     *                                 cFalse  ->  ''                                        RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   name          - The name (file or directory name) portion of the path.              RADDAT
     *=========================================================================              RADDAT
    P ifsPath_getName...                                                                     RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_getName...                                                                     RADDAT
     D                 PI                  like(ifs_path_t    )                               RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_isDirectory                   N   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D name            S                   like(ifs_path_t) inz                               RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_isDirectory   C                    2                                                 RADDAT
     *                                                                                       RADDAT
     *  Optional parameter fields                                                            RADDAT
     D isDirectory     S                   like(i_isDirectory ) inz(cFalse)                   RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D pToken          S               *   inz                                                RADDAT
     D token           S                   like(name      )  inz                              RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_codePage                                                                  //RADDAT
 B01     if (%parms() >= p_isDirectory);                                                    //RADDAT
            isDirectory = i_isDirectory;                                                    //RADDAT
 X01     else;                                                                              //RADDAT
            isDirectory = cFalse;                                                           //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //If the path ends with / or \, ...                                               //RADDAT
 B01     if (not isDirectory and
             (f_endsWith(cSLASH: i_path) or f_endsWith(cBACKSLASH: i_path)));               //RADDAT
            //... then it does not contain a file name                                     //RADDAT
            name = '';                                                                      //RADDAT
 X01     else;                                                                              //RADDAT
            //... else search for the last token of the path                               //RADDAT
            pToken = strtok(i_path: cDELIMITER);                                            //RADDAT
 B02        dow (pToken <> *NULL);                                                          //RADDAT
               token  = %str(pToken);                                                       //RADDAT
               pToken = strtok(*NULL: cDELIMITER);                                          //RADDAT
 E02        enddo;                                                                          //RADDAT
                                                                                            //RADDAT
            name = token;                                                                   //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (isDirectory and name <> '');                                                   //RADDAT
            name = ifsDirectory_fixSyntax(name);                                            //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return name;                                                                       //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_getName...                                                                     RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Retrieves the directory name from a given path name.                                 RADDAT
     *=========================================================================              RADDAT
     *  Attention: The ifsPath_getDirectory-function must also be able to                    RADDAT
     *             retrieve the directory name from pathes starting with 'http://'           RADDAT
     *             or 'ftp://'. Please consider that, when changing the                      RADDAT
     *             ifsPath_getDirectory-function.                                            RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given IFS path name.                                              RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   directory     - The directory name portion of the path.                             RADDAT
     *=========================================================================              RADDAT
    P ifsPath_getDirectory...                                                                RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_getDirectory...                                                                RADDAT
     D                 PI                  like(ifs_path_t    )                               RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D i_isDirectory                   N   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D directory       S                   like(ifs_path_t) inz                               RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_isDirectory   C                    2                                                 RADDAT
     *                                                                                       RADDAT
     *  Optional parameter fields                                                            RADDAT
     D isDirectory     S                   like(i_isDirectory ) inz(cFalse)                   RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D pathLength      S             10I 0 inz                                                RADDAT
     D dirLength       S             10I 0 inz                                                RADDAT
     D x               S             10I 0 inz                                                RADDAT
     D y               S             10I 0 inz                                                RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Process optional parameters ...                                                 //RADDAT
         //... i_codePage                                                                  //RADDAT
 B01     if (%parms() >= p_isDirectory);                                                    //RADDAT
            isDirectory = i_isDirectory;                                                    //RADDAT
 X01     else;                                                                              //RADDAT
            isDirectory = cFalse;                                                           //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //If the path ends with / or \, ...                                               //RADDAT
 B01     if (not isDirectory and
             f_endsWith(cSLASH: i_path) or f_endsWith(cBACKSLASH: i_path));                 //RADDAT
            //... then it does not contain an file name                                    //RADDAT
            //    and therefore the directory name is equal                                //RADDAT
            //    to the path  name.                                                       //RADDAT
            directory = i_path;                                                             //RADDAT
 X01     else;                                                                              //RADDAT
            //... else search for the last token of the path                               //RADDAT
            pathLength = %len(i_path);                                                      //RADDAT
            dirLength  = 0;                                                                 //RADDAT
 B02        for x = 1 to pathLength;                                                        //RADDAT
               y = %scan(%subst(i_path: x: 1): cDELIMITER);                                 //RADDAT
 B03           if (y > 0);                                                                  //RADDAT
                  dirLength = x;                                                            //RADDAT
 E03           endif;                                                                       //RADDAT
 E02        endfor;                                                                         //RADDAT
                                                                                            //RADDAT
            //retrieve the directory protion of the path                                   //RADDAT
 B02        if (dirLength > 0);                                                             //RADDAT
               directory = %subst(i_path: 1: dirLength);                                    //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return directory;                                                                  //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_getDirectory...                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Retrieves the file extension of the file name from a given path name.                RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The path name of a given IFS file.                                  RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   extension     - Returns the extension of the file name.                             RADDAT
     *=========================================================================              RADDAT
    P ifsPath_getExtension...                                                                RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_getExtension...                                                                RADDAT
     D                 PI                         like(ifs_path_t    )                        RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D extension       S                   like(ifs_path_t) inz                               RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D isPresent       S             10I 0                  inz                               RADDAT
     D file            S                   like(ifs_path_t) inz                               RADDAT
     D length          S             10I 0                  inz                               RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         file   = ifsPath_getName(i_path);                                                  //RADDAT
         length = %len(file) - 1;   //There must be at least one character                 //RADDAT
                                    //beyond the dot "."                                   //RADDAT
 B01     dow (length >= 1);                                                                 //RADDAT
                                                                                            //RADDAT
 B02        if (%subst(file: length: 1) = '.');                                             //RADDAT
               extension = %subst(file: length + 1);                                        //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            length = length - 1;                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
         //Set message type to *ESCAPE if it is not an OK message                          //RADDAT
 B01     if (msg.ID <> cMsg_ID_OK);                                                         //RADDAT
            msg.type = cMsg_Escape;                                                         //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return extension;                                                                  //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_getExtension...                                                                RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Removes the extension from an IFS file or path.                                      RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - The file or path.                                                   RADDAT
     *   o_msg         - Error message.                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   path_wo_ext   - The file or path without the extension.                             RADDAT
     *=========================================================================              RADDAT
    P ifsPath_removeExtension...                                                             RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_removeExtension...                                                             RADDAT
     D                 PI                         like(ifs_path_t    )                        RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D path_wo_ext     S                   like(ifs_path_t) inz                               RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  Local fields                                                                         RADDAT
     D isPresent       S             10I 0 inz                                                RADDAT
     D isFound         S               N   inz(cFalse)                                        RADDAT
     D length          S             10I 0 inz                                                RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         length = %len(i_path);                                                             //RADDAT
                                                                                            //RADDAT
 B01     dow length >= 2;   //There must be at least one character left                    //RADDAT
                            //before the dot "."                                           //RADDAT
 B02        if (%subst(i_path: length: 1) = cSLASH) or
 B02           (%subst(i_path: length: 1) = cBACKSLASH);                                    //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (%subst(i_path: length: 1) = '.');                                           //RADDAT
               path_wo_ext = %subst(i_path: 1: length - 1);                                 //RADDAT
               isFound = cTrue;                                                             //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            length = length - 1;                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if not isFound;                                                                    //RADDAT
            path_wo_ext = i_path;                                                           //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
         //Set message type to *ESCAPE if it is not an OK message                          //RADDAT
 B01     if (msg.ID <> cMsg_ID_OK);                                                         //RADDAT
            msg.type = cMsg_Escape;                                                         //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //If the message parameter was passed ...                                         //RADDAT
 B01     if (%parms() >= p_msg);                                                            //RADDAT
            //... and not omitted                                                          //RADDAT
 B02        if (%addr(o_msg) <> *NULL);                                                     //RADDAT
               //Return back message                                                       //RADDAT
               o_msg = msg;                                                                 //RADDAT
 E02        endif;                                                                          //RADDAT
 X01     else;                                                                              //RADDAT
            //... else send message                                                        //RADDAT
 B02        if (msg.ID <> cMsg_ID_OK);                                                      //RADDAT
               f_sndPgmMsg(msg: cMsg_Prv);                                                  //RADDAT
 E02        endif;                                                                          //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return path_wo_ext;                                                                //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_removeExtension...                                                             RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Fixes the syntax of a given IFS path name.                                           RADDAT
     *  (Hint:   path = directory + file)                                                    RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given IFS path name.                                              RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   path          - The fixed IFS path name.                                            RADDAT
     *=========================================================================              RADDAT
    P ifsPath_fixSyntax...                                                                   RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_fixSyntax...                                                                   RADDAT
     D                 PI                  like(ifs_path_t    )                               RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D path            S                   like(ifs_path_t) inz                               RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //If no path was specified, ...                                                   //RADDAT
 B01     if (i_path = '');                                                                  //RADDAT
         //... then return to caller                                                       //RADDAT
            return i_path;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //Translate backslashes ('\') to slashes ('/')                                    //RADDAT
         path = %xlate(cBACKSLASH: cSLASH: i_path);                                         //RADDAT
                                                                                            //RADDAT
         return path;                                                                       //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_fixSyntax...                                                                   RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given path is a directory, else cFalse.                           RADDAT
     *  (A path is considered to be a directory if it ends with a '/'.)                      RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   path          - Returns cTrue if a given path is a directory, else                  RADDAT
     *                   cFalse.                                                             RADDAT
     *=========================================================================              RADDAT
    P ifsPath_isDirectory...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_isDirectory...                                                                 RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
 B01     if (f_endsWith('/': i_path) or f_endsWith('\': i_path));                           //RADDAT
            return cTrue;                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_isDirectory...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given path is a file, else cFalse.                                RADDAT
     *  (A path is considered to be a file if it does not end with a '/'.)                   RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   path          - Returns cTrue if a given path is a file, else cFalse.               RADDAT
     *=========================================================================              RADDAT
    P ifsPath_isFile...                                                                      RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_isFile...                                                                      RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         return not ifsPath_isDirectory(i_path);                                            //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_isFile...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given path is an absolute path, else cFalse.                      RADDAT
     *  (A path is considered to be an absolute path if it does start with a '/'.)           RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   path          - Returns cTrue if a given path is an absolute path,                  RADDAT
     *                   else cFalse.                                                        RADDAT
     *=========================================================================              RADDAT
    P ifsPath_isAbsolute...                                                                  RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_isAbsolute...                                                                  RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
 B01     if (f_startsWith('/': i_path) or f_startsWith('\': i_path));                       //RADDAT
            return cTrue;                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_isAbsolute...                                                                  RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given path is a relative path, else cFalse.                       RADDAT
     *  (A path is considered to be a relative path if it does not start with a '/'.)        RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   path          - Returns cTrue if a given path is a relative path,                   RADDAT
     *                   else cFalse.                                                        RADDAT
     *=========================================================================              RADDAT
    P ifsPath_isRelative...                                                                  RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_isRelative...                                                                  RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         return not ifsPath_isAbsolute(i_path);                                             //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_isRelative...                                                                  RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given path does not contain a directory.                          RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   isNameOnly    - Returns cTrue if a given path does not contain a                    RADDAT
     *                   directory, else cFalse.                                             RADDAT
     *=========================================================================              RADDAT
    P ifsPath_isNameOnly...                                                                  RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_isNameOnly...                                                                  RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D slash           S             10I 0 inz                                                RADDAT
     D backslash       S             10I 0 inz                                                RADDAT
     D colon           S             10I 0 inz                                                RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         slash     = %scan(cSLASH    : %trimr(i_path));                                     //RADDAT
         backslash = %scan(cBACKSLASH: %trimr(i_path));                                     //RADDAT
         colon     = %scan(cCOLON    : %trimr(i_path));                                     //RADDAT
                                                                                            //RADDAT
 B01     if (ifsPath_isDirectory(i_path) and slash = %len(i_path));                         //RADDAT
            slash = 0;                                                                      //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (ifsPath_isDirectory(i_path) and backslash = %len(i_path));                     //RADDAT
            backslash = 0;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
 B01     if (slash = 0 and backslash = 0 and colon = 0);                                    //RADDAT
            return cTrue;                                                                   //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return cFalse;                                                                     //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_isNameOnly...                                                                  RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if a given path contains a file name pattern.                          RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name.                                                  RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   isPattern     - Returns cTrue if a given path contains a file name                  RADDAT
     *                   pattern, else cFalse.                                               RADDAT
     *=========================================================================              RADDAT
    P ifsPath_isPattern...                                                                   RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsPath_isPattern...                                                                   RADDAT
     D                 PI              N                                                      RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D name            S                   like(ifs_path_t )                                  RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         name = ifsPath_getName(i_path);                                                    //RADDAT
                                                                                            //RADDAT
 B01     if (%scan(cQUESTION_MARK: name) = 0 and %scan(cASTERISK: name) = 0);               //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return cTrue;                                                                      //RADDAT
                                                                                            //RADDAT
      /end-free
     *                                                                                       RADDAT
    P ifsPath_isPattern...                                                                   RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
