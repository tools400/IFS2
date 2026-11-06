**FREE
/IF NOT DEFINED(PIFS2)
/DEFINE PIFS2
//
// --------------------------------
//  Constants
// --------------------------------
DCL-C cIFS_CONTINUE *ON;
DCL-C cIFS_CANCEL *OFF;
//
DCL-C cIFS_OK 0;
DCL-C cIFS_ERROR -1;
DCL-C cIFS_EOF -2;
//
DCL-C cIFS_EOL_CRLF x'0D25';
DCL-C cIFS_EOL_LF x'25';
DCL-C cIFS_EOL_CR x'0D';
DCL-C cIFS_EOL_ANY x'00';
//
DCL-C cIFS_READDIR_DFT 11; // x'0000000B'
DCL-C cIFS_READDIR_FILE 1; // x'00000001'
DCL-C cIFS_READDIR_DIRECTORY 2; // x'00000002'
DCL-C cIFS_READDIR_ALL 4; // x'00000004'
DCL-C cIFS_READDIR_CB_NAME 8; // x'00000008'
DCL-C cIFS_READDIR_CB_DIRENT 16; // x'00000010'
DCL-C cIFS_READDIR_SUBDIRECTORY 32; // x'00000020'
DCL-C cIFS_READDIR_PRE_ORDER 64; // x'00000040'
DCL-C cIFS_READDIR_POST_ORDER 128; // x'00000080'
DCL-C cIFS_READDIR_RESOLVE_SYMLNK 4096; // x'00001000'
//
DCL-C cIFS_DIRENT_TYPE_FILE '*STMF';
DCL-C cIFS_DIRENT_TYPE_DOCUMENT '*DOC';
DCL-C cIFS_DIRENT_TYPE_DIRECTORY '*DIR';
DCL-C cIFS_DIRENT_TYPE_FOLDER '*FLR';
DCL-C cIFS_DIRENT_TYPE_SYMBOLIC_LINK '*SYMLNK';
//
DCL-C cIFS_MKDIR_DFT 0; // x'00000000'
DCL-C cIFS_MKDIR_SUBDIR 1; // x'00000001'
//
DCL-C cIFS_RMDIR_DFT 0; // x'00000000'
DCL-C cIFS_RMDIR_DELETE_SUB_DIRECTORIES 1; // x'00000001'
//
DCL-C cIFS_COPY_FILE_CCSID_SAME 0;
DCL-C cIFS_COPY_FILE_DFT 0; // x'00000000'
DCL-C cIFS_COPY_FILE_REPLACE 1; // x'00000001'
DCL-C cIFS_COPY_FILE_APPEND 2; // x'00000002'
DCL-C cIFS_COPY_FILE_CREATE_DIRECTORY 4; // x'00000004'
//
DCL-C cIFS_MOVE_FILE_DFT 0;
DCL-C cIFS_MOVE_FILE_REPLACE 1; // x'00000001'
DCL-C cIFS_MOVE_FILE_ALLOW_RENAME 2; // x'00000002'
DCL-C cIFS_MOVE_FILE_CREATE_DIRECTORY 4; // x'00000004'
//
// --------------------------------
//  Callback Procedures
// --------------------------------
DCL-PR ifsDirectory_read_Path IND EXTPROC('ifsDirectory_read_Path');
  i_level     INT(10) CONST;
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_entry     CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_type      CONST LIKE(ifs_type_t);
  i_pUserData POINTER CONST;
  o_msg       LIKEDS(msg_t);
END-PR;
//
DCL-PR ifsDirectory_read_Dirent IND EXTPROC('ifsDirectory_read_Dirent');
  i_level     INT(10) CONST;
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_dirent    CONST LIKEDS(dirent_t);
  i_type      CONST LIKE(ifs_type_t);
  i_pUserData POINTER CONST;
  o_msg       LIKEDS(msg_t);
END-PR;
//
//  Type definitions
DCL-S ifs_path_t VARCHAR(5000) BASED(pDummy);
DCL-S ifs_hFile_t LIKE(HANDLE_handle_t) BASED(pDummy);
DCL-S ifs_EOLChar_t VARCHAR(32) BASED(pDummy);
DCL-S ifs_type_t CHAR(10) BASED(pDummy);
DCL-S ifs_fileID_t CHAR(32) BASED(pDummy);
DCL-S ifs_ccsid_t UNS(10) BASED(pDummy);
//
DCL-DS ifs_uniqueFileID_t QUALIFIED BASED(pDummy);
  ino UNS(10);
  dev UNS(20);
END-DS;
//
// --------------------------------
//  Imported prototypes
// --------------------------------
/COPY QIFS2,CLIB  C Runtime Library
/COPY QBASICS1,PBASICS1  Tools/400 Runtime Library
//
// --------------------------------
//  Exported procedures
// --------------------------------
//
//  Returns cTrue if the specified file exists, else cFalse.
DCL-PR ifsFile_exist IND EXTPROC('IFS2R01_ifsFile_exist');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Opens a given stream file.
DCL-PR ifsFile_open LIKE(ifs_hFile_t) EXTPROC('IFS2R01_ifsFile_open');
  i_path     CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_opnFlags INT(10) CONST;
  i_codePage INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  i_pubAuth  INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Closes an stream file that has been opened with the ifsFile_open-function.
DCL-PR ifsFile_close INT(10) EXTPROC('IFS2R01_ifsFile_close');
  io_hFile LIKE(ifs_hFile_t);
  o_msg    LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Deletes a given stream file.
DCL-PR ifsFile_delete INT(10) EXTPROC('IFS2R01_ifsFile_delete');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Moves a given stream file to a new location.
DCL-PR ifsFile_move INT(10) EXTPROC('IFS2R01_ifsFile_move');
  i_fromPath CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_toDir    CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_options  INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Renames a given stream file.
DCL-PR ifsFile_rename INT(10) EXTPROC('IFS2R01_ifsFile_rename');
  i_fromPath CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_toFile   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Copyies a given file to a directory or another file.
DCL-PR ifsFile_copy INT(10) EXTPROC('IFS2R01_ifsFile_copy');
  i_fromPath CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_toPath   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_options  INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  i_ccsid    CONST LIKE(ifs_ccsid_t) OPTIONS(*NOPASS: *OMIT);
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Sets the read/write pointer of an open stream file to a new position.
DCL-PR ifsFile_seek INT(10) EXTPROC('IFS2R01_ifsFile_seek');
  i_hFile  CONST LIKE(ifs_hFile_t);
  i_offset INT(10) CONST;
  i_whence INT(10) CONST;
  o_msg    LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Reads data from a given stream file.
DCL-PR ifsFile_read INT(10) EXTPROC('IFS2R01_ifsFile_read');
  i_hFile   CONST LIKE(ifs_hFile_t);
  o_pBuffer POINTER CONST;
  i_length  INT(10) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Writes data to a given stream file.
DCL-PR ifsFile_write INT(10) EXTPROC('IFS2R01_ifsFile_write');
  i_hFile   CONST LIKE(ifs_hFile_t);
  i_pBuffer POINTER CONST OPTIONS(*STRING);
  i_length  INT(10) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Reads a line from a given stream file.
DCL-PR ifsFile_readLine INT(10) EXTPROC('IFS2R01_ifsFile_readLine');
  i_hFile   CONST LIKE(ifs_hFile_t);
  o_pBuffer POINTER CONST;
  i_length  INT(10) CONST;
  i_EOLChar CONST LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT);
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Writes line to a given stream file.
DCL-PR ifsFile_writeLine INT(10) EXTPROC('IFS2R01_ifsFile_writeLine');
  i_hFile   CONST LIKE(ifs_hFile_t);
  i_pBuffer POINTER CONST OPTIONS(*STRING);
  i_length  INT(10) CONST;
  i_EOLChar CONST LIKE(ifs_EOLChar_t) OPTIONS(*NOPASS: *OMIT);
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the size on a given stream file.
DCL-PR ifsFile_getSize INT(10) EXTPROC('IFS2R01_ifsFile_getSize');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the size of the file referenced by a given file handle.
DCL-PR ifsFile_getSizeH INT(10) EXTPROC('IFS2R01_ifsFile_getSizeH');
  i_hFile CONST LIKE(ifs_hFile_t);
  o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Changes the size on a given stream file.
DCL-PR ifsFile_setSize INT(10) EXTPROC('IFS2R01_ifsFile_setSize');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Changes the size of the file referenced by a given file handle.
DCL-PR ifsFile_setSizeH INT(10) EXTPROC('IFS2R01_ifsFile_setSizeH');
  i_hFile   CONST LIKE(ifs_hFile_t);
  i_newSize INT(10) CONST;
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the creation timestamp of a given stream file.
DCL-PR ifsFile_getCreationTime TIMESTAMP EXTPROC('IFS2R01_ifsFile_getCreationTime');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the timestamp the stream file data was last changed.
DCL-PR ifsFile_getDataChangeTime TIMESTAMP EXTPROC('IFS2R01_ifsFile_getDataChangeTime');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the file ID that uniquely identifies a given stream file.
DCL-PR ifsFile_getUniqueID LIKEDS(ifs_uniqueFileID_t) EXTPROC('IFS2R01_ifsFile_getUniqueID');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the unique file ID of the file referenced by a given file handle.
DCL-PR ifsFile_getUniqueIDH LIKEDS(ifs_uniqueFileID_t) EXTPROC('IFS2R01_ifsFile_getUniqueIDH');
  i_hFile CONST LIKE(ifs_hFile_t);
  o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the file ID as shown at the WRKLNK 'Display Attributes' screen.
DCL-PR ifsFile_getID CHAR(32) EXTPROC('IFS2R01_ifsFile_getID');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the file ID of the file referenced by a given file handle
//   as shown at the WRKLNK 'Display Attributes' screen.
DCL-PR ifsFile_getIDH CHAR(32) EXTPROC('IFS2R01_ifsFile_getIDH');
  i_hFile CONST LIKE(ifs_hFile_t);
  o_msg   LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Produces a unique temporary stream file name.
DCL-PR ifsFile_getTempPath LIKE(ifs_path_t) EXTPROC('IFS2R01_ifsFile_getTempPath');
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Compares the content of two files with each other.
DCL-PR ifsFile_compare INT(10) EXTPROC('IFS2R01_ifsFile_compare');
  i_path1   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_path2   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_options INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  o_msg     LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns cTrue if the specified directory exists, else cFalse.
DCL-PR ifsDirectory_exist IND EXTPROC('IFS2R02_ifsDirectory_exist');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Creates a new directory.
DCL-PR ifsDirectory_create INT(10) EXTPROC('IFS2R02_ifsDirectory_create');
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_options   INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  i_auth      INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Deletes a given directory.
DCL-PR ifsDirectory_remove INT(10) EXTPROC('IFS2R02_ifsDirectory_remove');
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_options   INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Moves a given directory to a new location.
DCL-PR ifsDirectory_move INT(10) EXTPROC('IFS2R01_ifsDirectory_move');
  i_fromPath CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_toDir    CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_options  INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  o_msg      LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Renames a given directory.
DCL-PR ifsDirectory_rename INT(10) EXTPROC('IFS2R01_ifsDirectory_rename');
  i_fromDirectory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_toDirectory   CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg           LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Reads the entries of a given directory.
DCL-PR ifsDirectory_read INT(10) EXTPROC('IFS2R02_ifsDirectory_read');
  i_path      CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_pCallback POINTER(*PROC) CONST;
  i_options   INT(10) CONST OPTIONS(*NOPASS: *OMIT);
  i_pUserData POINTER CONST OPTIONS(*NOPASS: *OMIT);
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns cTrue if a given directory is empty, else cFalse.
DCL-PR ifsDirectory_isEmpty IND EXTPROC('IFS2R02_ifsDirectory_isEmpty');
  i_dir CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the current working directory.
DCL-PR ifsDirectory_getCurrent LIKE(ifs_path_t) EXTPROC('IFS2R02_ifsDirectory_getCurrent');
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Changes the current working directory.
DCL-PR ifsDirectory_setCurrent INT(10) EXTPROC('IFS2R02_ifsDirectory_setCurrent');
  i_dir CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Fixes the syntax of a given directory name.
DCL-PR ifsDirectory_fixSyntax LIKE(ifs_path_t) EXTPROC('IFS2R02_ifsDirectory_fixSyntax');
  i_dir CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns the creation timestamp of a given directory.
DCL-PR ifsDirectory_getCreationTime TIMESTAMP EXTPROC('IFS2R02_ifsDirectory_getCreationTime');
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Returns the timestamp the content of the directory was last changed.
DCL-PR ifsDirectory_getContentChangeTime TIMESTAMP EXTPROC('IFS2R02_ifsDirectory_getContentChangeTi+
  me');
  i_directory CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg       LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Retrieves the stream file name from a given path name.
DCL-PR ifsPath_getName LIKE(ifs_path_t) EXTPROC('IFS2R03_ifsPath_getName');
  i_path        CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_isDirectory IND CONST OPTIONS(*NOPASS);
END-PR;
//
//  Retrieves the directory name from a given path name.
DCL-PR ifsPath_getDirectory LIKE(ifs_path_t) EXTPROC('IFS2R03_ifsPath_getDirectory');
  i_path        CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  i_isDirectory IND CONST OPTIONS(*NOPASS);
END-PR;
//
//  Retrieves the file extension of the stream file name from a given path name.
DCL-PR ifsPath_getExtension LIKE(ifs_path_t) EXTPROC('IFS2R03_ifsPath_getExtension');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Removes the extension from an stream file or path.
DCL-PR ifsPath_removeExtension LIKE(ifs_path_t) EXTPROC('IFS2R03_ifsPath_removeExtension');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
//  Fixes the syntax of a given path name.
DCL-PR ifsPath_fixSyntax LIKE(ifs_path_t) EXTPROC('IFS2R03_ifsPath_fixSyntax');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given path is a directory, else cFalse.
//  (A path is considered to be a directory if it ends with a '/'.)
DCL-PR ifsPath_isDirectory IND EXTPROC('IFS2R03_ifsPath_isDirectory');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given path is a file, else cFalse.
//  (A path is considered to be a file if it does not end with a '/'.)
DCL-PR ifsPath_isFile IND EXTPROC('IFS2R03_ifsPath_isFile');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given path is an absolute path, else cFalse.
//  (A path is considered to be an absolute path if it does start with a '/'.)
DCL-PR ifsPath_isAbsolute IND EXTPROC('IFS2R03_ifsPath_isAbsolute');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given path is a relative path, else cFalse.
//  (A path is considered to be a relative path if it does not start with a '/'.)
DCL-PR ifsPath_isRelative IND EXTPROC('IFS2R03_ifsPath_isRelative');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given path does not contain a directory.
DCL-PR ifsPath_isNameOnly IND EXTPROC('IFS2R03_ifsPath_isNameOnly');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if a given path does contain a file name pattern.
DCL-PR ifsPath_isPattern IND EXTPROC('IFS2R03_ifsPath_isPattern');
  i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
END-PR;
//
//  Returns cTrue if the type of a given directory entry indicates
//  that the entry is a directory, else cFalse.
DCL-PR ifsType_isDirectory IND EXTPROC('IFS2R06_ifsType_isDirectory');
  i_objType CONST LIKE(st_stat_t.objType);
END-PR;
//
//  Returns cTrue if the type of a given directory entry indicates
//  that the entry is a file, else cFalse.
DCL-PR ifsType_isFile IND EXTPROC('IFS2R06_ifsType_isFile');
  i_objType CONST LIKE(st_stat_t.objType);
END-PR;
//
//  Returns cTrue if the type of a given directory entry indicates
//  that the entry is a symbolic link, else cFalse.
DCL-PR ifsType_isSymbolicLink IND EXTPROC('IFS2R06_ifsType_isSymbolicLink');
  i_objType CONST LIKE(st_stat_t.objType);
END-PR;
//
//  Returns the real object type of a symbolic link.
DCL-PR ifsSymLnk_getRealType LIKE(ifs_type_t) EXTPROC('IFS2R07_ifsSymLnk_getRealType');
  i_path CONST LIKE(ifs_path_t);
  o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
END-PR;
//
/ENDIF
