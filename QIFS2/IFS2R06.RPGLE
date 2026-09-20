     *=====================================================================*                 RADDAT
     *  IFS2R06    - Tools/400: Stream File and Directory - ObjType        *                 RADDAT
     *=====================================================================*                 RADDAT
     *  Author  :  Thomas Raddatz                                          *                 RADDAT
     *  Date    :  12.02.2009                                              *                 RADDAT
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
     *  Returns cTrue if the type of a given directory entry indicates                       RADDAT
     *  that the entry is a directory, else cFalse.                                          RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_type        - Type of directory entry as returned by the stat()                   RADDAT
     *                   function and as passed to the ifsDirectory_read                     RADDAT
     *                   callback procedures.                                                RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   isDirectory   - Returns cTrue for directories, else cFalse.                         RADDAT
     *=========================================================================              RADDAT
    P ifsType_isDirectory...                                                                 RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsType_isDirectory...                                                                 RADDAT
     D                 PI              N                                                      RADDAT
     D i_objtype                           const  like(st_stat_t.objType)                     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (i_objType = cIFS_DIRENT_TYPE_DIRECTORY) or
            (i_objType = cIFS_DIRENT_TYPE_FOLDER);                                          //RADDAT
            return cTrue;                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsType_isDirectory...                                                                 RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if the type of a given directory entry indicates                       RADDAT
     *  that the entry is a file, else cFalse.                                               RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_type        - Type of directory entry as returned by the stat()                   RADDAT
     *                   function and as passed to the ifsDirectory_read                     RADDAT
     *                   callback procedures.                                                RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   isFile        - Returns cTrue for files, else cFalse.                               RADDAT
     *=========================================================================              RADDAT
    P ifsType_isFile...                                                                      RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsType_isFile...                                                                      RADDAT
     D                 PI              N                                                      RADDAT
     D i_objtype                           const  like(st_stat_t.objType)                     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (i_objType = cIFS_DIRENT_TYPE_FILE) or
            (i_objType = cIFS_DIRENT_TYPE_DOCUMENT);                                        //RADDAT
            return cTrue;                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsType_isFile...                                                                      RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
     *=========================================================================              RADDAT
     *  Returns cTrue if the type of a given directory entry indicates                       RADDAT
     *  that the entry is a symbolic link, else cFalse.                                      RADDAT
     *=========================================================================              RADDAT
     *  Parameters:                                                                          RADDAT
     *   i_type        - Type of directory entry as returned by the stat()                   RADDAT
     *                   function and as passed to the ifsDirectory_read                     RADDAT
     *                   callback procedures.                                                RADDAT
     *                                                                                       RADDAT
     *  Returns:                                                                             RADDAT
     *   isFile        - Returns cTrue for symbolic links, else cFalse.                      RADDAT
     *=========================================================================              RADDAT
    P ifsType_isSymbolicLink...                                                              RADDAT
    P                 B                   export                                             RADDAT
     *                                                                                       RADDAT
     D ifsType_isSymbolicLink...                                                              RADDAT
     D                 PI              N                                                      RADDAT
     D i_objtype                           const  like(st_stat_t.objType)                     RADDAT
     * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
 B01     if (i_objType = cIFS_DIRENT_TYPE_SYMBOLIC_LINK);                                   //RADDAT
            return cTrue;                                                                   //RADDAT
 X01     else;                                                                              //RADDAT
            return cFalse;                                                                  //RADDAT
 E01     endif;                                                                             //RADDAT
                                                                                            //RADDAT
      /END-FREE
     *                                                                                       RADDAT
    P ifsType_isSymbolicLink...                                                              RADDAT
    P                 E                                                                      RADDAT
     *                                                                                       RADDAT
