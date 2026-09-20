     *=====================================================================*                 RADDAT
     *  IFS2R05    - Tools/400: Stream File and Directory - Application    *                 RADDAT
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
CPY  /COPY QIFS2,PIFS2R05                                                                   RADDAT
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
     *                                                                                       RADDAT
     * ------------------------------------                                                  RADDAT
     *  Global fields                                                                        RADDAT
     * ------------------------------------                                                  RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Kills the IFS service program by sending a given ESCAPE message.                     RADDAT
     *=========================================================================              RADDAT
    P Application_killWithMsg...                                                             RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D Application_killWithMsg...                                                             RADDAT
     D                 PI                                                                     RADDAT
     D  i_msg                              value  likeds(msg_t     )                          RADDAT
     * ---------------------------------------------------------                             RADDAT
      /free
                                                                                            //RADDAT
         i_msg.type = cMsg_Escape;                                                          //RADDAT
         f_sndPgmMsg(i_msg: 2: f_caller());                                                 //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P Application_killWithMsg...                                                             RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
