**FREE
//=====================================================================*
//  IFS2R06    - Tools/400: Stream File and Directory - ObjType        *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  12.02.2009                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
// =================================================================== *
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//                                                                     *
//   >>COMPILE<<                                                       *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< TRUNCNBR(*NO );                                        *
//     >>PARM<< TGTRLS(V7R3M0);                                        *
//   >>END-COMPILE<<                                                   *
//                                                                     *
//   >>EXECUTE<<                                                       *
//                                                                     *
// >>END-PRE-COMPILER<<                                                *
// =================================================================== *
CTL-OPT NOMAIN;
/COPY QIFS2,H_SPEC 
// =================================================================== *
//
// ------------------------------------
//  Exported prototypes
// ------------------------------------
/COPY QIFS2,PIFS2 
//
// ------------------------------------
//  Imported prototypes
// ------------------------------------
/COPY QIFS2,CEELIB  CEE APIs
//
// ------------------------------------
//  Private prototypes
// ------------------------------------
//
// ------------------------------------
//  Type definitions
// ------------------------------------
/COPY QIFS2,TYPES 
//
// ------------------------------------
//  Global constants
// ------------------------------------
//
// ------------------------------------
//  Global fields
// ------------------------------------
//
//=========================================================================
//  Returns cTrue if the type of a given directory entry indicates
//  that the entry is a directory, else cFalse.
//=========================================================================
//  Parameters:
//   i_type        - Type of directory entry as returned by the stat()
//                   function and as passed to the ifsDirectory_read
//                   callback procedures.
//
//  Returns:
//   isDirectory   - Returns cTrue for directories, else cFalse.
//=========================================================================
DCL-PROC ifsType_isDirectory EXPORT;
  //
  DCL-PI *N IND;
    i_objtype CONST LIKE(st_stat_t.objType);
  END-PI;
  // ---------------------------------------------------------

  if (i_objType = cIFS_DIRENT_TYPE_DIRECTORY) or
     (i_objType = cIFS_DIRENT_TYPE_FOLDER);
    return cTrue;
  else;
    return cFalse;
  endif;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if the type of a given directory entry indicates
//  that the entry is a file, else cFalse.
//=========================================================================
//  Parameters:
//   i_type        - Type of directory entry as returned by the stat()
//                   function and as passed to the ifsDirectory_read
//                   callback procedures.
//
//  Returns:
//   isFile        - Returns cTrue for files, else cFalse.
//=========================================================================
DCL-PROC ifsType_isFile EXPORT;
  //
  DCL-PI *N IND;
    i_objtype CONST LIKE(st_stat_t.objType);
  END-PI;
  // ---------------------------------------------------------

  if (i_objType = cIFS_DIRENT_TYPE_FILE) or
     (i_objType = cIFS_DIRENT_TYPE_DOCUMENT);
    return cTrue;
  else;
    return cFalse;
  endif;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if the type of a given directory entry indicates
//  that the entry is a symbolic link, else cFalse.
//=========================================================================
//  Parameters:
//   i_type        - Type of directory entry as returned by the stat()
//                   function and as passed to the ifsDirectory_read
//                   callback procedures.
//
//  Returns:
//   isFile        - Returns cTrue for symbolic links, else cFalse.
//=========================================================================
DCL-PROC ifsType_isSymbolicLink EXPORT;
  //
  DCL-PI *N IND;
    i_objtype CONST LIKE(st_stat_t.objType);
  END-PI;
  // ---------------------------------------------------------

  if (i_objType = cIFS_DIRENT_TYPE_SYMBOLIC_LINK);
    return cTrue;
  else;
    return cFalse;
  endif;

//
END-PROC;
//
