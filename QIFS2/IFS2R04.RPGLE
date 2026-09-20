     *=====================================================================*                 RADDAT
     *  IFS2R04    - Tools/400: Stream File and Directory - App.Msg        *                 RADDAT
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
CPY  /COPY QIFS2,PIFS2R04                                                                   RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Imported prototypes                                                                  RADDAT
     * ------------------------------------                                                  RADDAT
CPY  /COPY QBASICS1,PBASICS1                                                                RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Private prototypes                                                                   RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global constants                                                                     RADDAT
     * ------------------------------------                                                  RADDAT
     D cAPP_MSG_FILE...                                                                       RADDAT
     D                 C                   'IFS2ENG'                                          RADDAT
     D cAPP_MSG_FILE_LIBRARY...                                                               RADDAT
     D                 C                   '*LIBL'                                            RADDAT
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Creates an application message.                                                      RADDAT
     *=========================================================================              RADDAT
    P AppMsg_new...                                                                          RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D AppMsg_new...                                                                          RADDAT
     D                 PI                         likeds(msg_t     )                          RADDAT
     D  i_ID                               const  like(msg_t.ID    )                          RADDAT
     D  i_data                             const  like(msg_t.data  )                          RADDAT
     D                                            options(*nopass)                            RADDAT
     D  i_type                             const  like(msg_t.data  )                          RADDAT
     D                                            options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D msg             DS                  likeds(msg_t ) inz                                 RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_data          C                   2                                                  RADDAT
     D p_type          C                   3                                                  RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D data            S                   like(i_data  ) inz                                 RADDAT
     D type            S                   like(i_type  ) inz                                 RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Get optional parameter values ...                                               //RADDAT
         //... data                                                                        //RADDAT
 B01     if (%parms() >= p_data);                                                           //RADDAT
            data = i_data;                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            data = '';                                                                      //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         //... type                                                                        //RADDAT
 B01     if (%parms() >= p_type);                                                           //RADDAT
            type = i_type;                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            type = cMsg_Info;                                                               //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         msg = f_newMsg(i_ID: data: type: cAPP_MSG_FILE: cAPP_MSG_FILE_LIBRARY);            //RADDAT
                                                                                            //RADDAT
         return msg;                                                                        //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P AppMsg_new...                                                                          RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Creates an application ESCAPE message.                                               RADDAT
     *=========================================================================              RADDAT
    P AppMsg_newEscape...                                                                    RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D AppMsg_newEscape...                                                                    RADDAT
     D                 PI                         likeds(msg_t     )                          RADDAT
     D  i_ID                               const  like(msg_t.ID    )                          RADDAT
     D  i_data                             const  like(msg_t.data  )                          RADDAT
     D                                            options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Return value                                                                         RADDAT
     D msg             DS                  likeds(msg_t ) inz                                 RADDAT
     *                                                                                       RADDAT
     *  Parameter positions                                                                  RADDAT
     D p_data          C                   2                                                  RADDAT
     *                                                                                       RADDAT
     *  Fields for optional parameters                                                       RADDAT
     D data            S                   like(i_data  ) inz                                 RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         //Get optional parameter values ...                                               //RADDAT
         //... data                                                                        //RADDAT
 B01     if (%parms() >= p_data);                                                           //RADDAT
            data = i_data;                                                                  //RADDAT
 X01     else;                                                                              //RADDAT
            data = '';                                                                      //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
         msg = f_newMsg(i_ID: data: cMsg_Escape
                        : cAPP_MSG_FILE: cAPP_MSG_FILE_LIBRARY);                            //RADDAT
                                                                                            //RADDAT
         return msg;                                                                        //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P AppMsg_newEscape...                                                                    RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
