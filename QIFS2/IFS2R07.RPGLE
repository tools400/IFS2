     *=====================================================================*                 RADDAT
     *  IFS2R07    - Tools/400: Stream File and Directory - SymLnk         *                 RADDAT
     *=====================================================================*                 RADDAT
     *  Author  :  Thomas Raddatz                                          *                 RADDAT
     *  Date    :  22.12.2009                                              *                 RADDAT
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
CPY  /COPY QIFS2,PIFS2R04                        App.Msg                                    RADDAT
CPY  /COPY QIFS2,PIFS2R99                        Miscellaneous                              RADDAT
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
     *  Returns the real object type of a symbolic link.                                     RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_path        - A given path name of a symbolic link.                               RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   objType       - Real object type of a symbolic link.                                RADDAT
     *=========================================================================              RADDAT
    P ifsSymLnk_getRealType...                                                               RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsSymLnk_getRealType...                                                               RADDAT
     D                 PI                         like(ifs_type_t  )                          RADDAT
     D i_path                              const  like(ifs_path_t  )                          RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D objType         S                   like(ifs_type_t  ) inz                             RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_msg           C                   const(2)                                           RADDAT
     *                                                                                       RADDAT
     *  Helper fields                                                                        RADDAT
     D isPresent       S             10I 0 inz                                                RADDAT
     D msg             DS                  likeds(msg_t    ) inz                              RADDAT
     *                                                                                       RADDAT
     *  stat() result data structure                                                         RADDAT
     D st_stat         DS                  likeds(st_stat_t) inz                              RADDAT
     *                                                                                       RADDAT
     *  Messages                                                                             RADDAT
CPY  /COPY QIFS2,IFS1050                         Attributes of symbolic link '&1' not ...   RADDAT
CPY  /COPY QIFS2,IFS1051                         Symbolic link '&1' does not exist.         RADDAT
CPY  /COPY QIFS2,IFS1052                         The specified object '&1' is not a ...     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         //Clear error message                                                             //RADDAT
         msg = AppMsg_new(cMsg_ID_OK);                                                      //RADDAT
                                                                                            //RADDAT
 B01     dou '1';                                                                           //RADDAT
                                                                                            //RADDAT
            objType = '';                                                                   //RADDAT
                                                                                            //RADDAT
 B02        if (lstat(ifsPath_fixSyntax(i_path): %addr(st_stat)) = RC_ERROR);               //RADDAT
               clear IFS1051;                                                               //RADDAT
               IFS10511 = i_path;                                                           //RADDAT
               IFS10512 = f_errno();                                                        //RADDAT
               IFS10513 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1051': IFS1051);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (not STAT_isSymbolicLink(st_stat));                                          //RADDAT
               clear IFS1052;                                                               //RADDAT
               IFS10521 = i_path;                                                           //RADDAT
               msg = AppMsg_newEscape('IFS1052': IFS1052);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
 B02        if (stat(ifsPath_fixSyntax(i_path): %addr(st_stat)) = RC_ERROR);                //RADDAT
               clear IFS1050;                                                               //RADDAT
               IFS10501 = i_path;                                                           //RADDAT
               IFS10502 = f_errno();                                                        //RADDAT
               IFS10503 = f_strerror(f_errno());                                            //RADDAT
               msg = AppMsg_newEscape('IFS1050': IFS1050);                                  //RADDAT
               leave;                                                                       //RADDAT
 E02        endif;                                                                          //RADDAT
                                                                                            //RADDAT
            objType = %str(%addr(st_stat.objType));                                         //RADDAT
                                                                                            //RADDAT
 E01     enddo;                                                                             //RADDAT
                                                                                            //RADDAT
         //Ensure that message has been correctly set                                      //RADDAT
         p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);                           //RADDAT
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
         return objType;                                                                    //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsSymLnk_getRealType...                                                               RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
