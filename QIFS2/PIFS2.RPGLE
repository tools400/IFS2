 DEF  /IF NOT DEFINED(PIFS2)                                                                  RADDAT
 DEF  /DEFINE PIFS2                                                                           RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Constants                                                                            RADDAT
     * --------------------------------                                                      RADDAT
     D cIFS_CONTINUE...                                                                       RADDAT
     D                 C                   const(*ON)                                         RADDAT
     D cIFS_CANCEL...                                                                         RADDAT
     D                 C                   const(*OFF)                                        RADDAT
     *                                                                                       RADDAT
     D cIFS_OK...                                                                             RADDAT
     D                 C                   const(0)                                           RADDAT
     D cIFS_ERROR...                                                                          RADDAT
     D                 C                   const(-1)                                          RADDAT
     D cIFS_EOF...                                                                            RADDAT
     D                 C                   const(-2)                                          RADDAT
     *                                                                                       RADDAT
     D cIFS_EOL_CRLF...                                                                       RADDAT
     D                 C                   const(x'0D25')                                     RADDAT
     D cIFS_EOL_LF...                                                                         RADDAT
     D                 C                   const(x'25')                                       RADDAT
     D cIFS_EOL_CR...                                                                         RADDAT
     D                 C                   const(x'0D')                                       RADDAT
     D cIFS_EOL_ANY...                                                                        RADDAT
     D                 C                   const(x'00')                                       RADDAT
     *                                                                                       RADDAT
     D cIFS_READDIR_DFT...                                                                    RADDAT
     D                 C                   const(11)                            x'0000000B'   RADDAT
     D cIFS_READDIR_FILE...                                                                   RADDAT
     D                 C                   const(   1)                          x'00000001'   RADDAT
     D cIFS_READDIR_DIRECTORY...                                                              RADDAT
     D                 C                   const(   2)                          x'00000002'   RADDAT
     D cIFS_READDIR_ALL...                                                                    RADDAT
     D                 C                   const(   4)                          x'00000004'   RADDAT
     D cIFS_READDIR_CB_NAME...                                                                RADDAT
     D                 C                   const(   8)                          x'00000008'   RADDAT
     D cIFS_READDIR_CB_DIRENT...                                                              RADDAT
     D                 C                   const(  16)                          x'00000010'   RADDAT
     D cIFS_READDIR_SUBDIRECTORY...                                                           RADDAT
     D                 C                   const(  32)                          x'00000020'   RADDAT
     D cIFS_READDIR_PRE_ORDER...                                                              RADDAT
     D                 C                   const(  64)                          x'00000040'   RADDAT
     D cIFS_READDIR_POST_ORDER...                                                             RADDAT
     D                 C                   const( 128)                          x'00000080'   RADDAT
     D cIFS_READDIR_RESOLVE_SYMLNK...                                                         RADDAT
     D                 C                   const(4096)                          x'00001000'   RADDAT
     *                                                                                       RADDAT
     D cIFS_DIRENT_TYPE_FILE...                                                               RADDAT
     D                 C                   const('*STMF')                                     RADDAT
     D cIFS_DIRENT_TYPE_DOCUMENT...                                                           RADDAT
     D                 C                   const('*DOC')                                      RADDAT
     D cIFS_DIRENT_TYPE_DIRECTORY...                                                          RADDAT
     D                 C                   const('*DIR')                                      RADDAT
     D cIFS_DIRENT_TYPE_FOLDER...                                                             RADDAT
     D                 C                   const('*FLR')                                      RADDAT
     D cIFS_DIRENT_TYPE_SYMBOLIC_LINK...                                                      RADDAT
     D                 C                   const('*SYMLNK')                                   RADDAT
     *                                                                                       RADDAT
     D cIFS_MKDIR_DFT...                                                                      RADDAT
     D                 C                   const(0)                             x'00000000'   RADDAT
     D cIFS_MKDIR_SUBDIR...                                                                   RADDAT
     D                 C                   const(1)                             x'00000001'   RADDAT
     *                                                                                       RADDAT
     D cIFS_RMDIR_DFT...                                                                      RADDAT
     D                 C                   const(0)                             x'00000000'   RADDAT
     D cIFS_RMDIR_DELETE_SUB_DIRECTORIES...                                                   RADDAT
     D                 C                   const(1)                             x'00000001'   RADDAT
     *                                                                                       RADDAT
     D cIFS_COPY_FILE_CCSID_SAME...                                                           RADDAT
     D                 C                   const(0)                                           RADDAT
     D cIFS_COPY_FILE_DFT...                                                                  RADDAT
     D                 C                   const(0)                             x'00000000'   RADDAT
     D cIFS_COPY_FILE_REPLACE...                                                              RADDAT
     D                 C                   const(1)                             x'00000001'   RADDAT
     D cIFS_COPY_FILE_APPEND...                                                               RADDAT
     D                 C                   const(2)                             x'00000002'   RADDAT
     D cIFS_COPY_FILE_CREATE_DIRECTORY...                                                     RADDAT
     D                 C                   const(4)                             x'00000004'   RADDAT
     *                                                                                       RADDAT
     D cIFS_MOVE_FILE_DFT...                                                                  RADDAT
     D                 C                   const(0)                                           RADDAT
     D cIFS_MOVE_FILE_REPLACE...                                                              RADDAT
     D                 C                   const(1)                             x'00000001'   RADDAT
     D cIFS_MOVE_FILE_ALLOW_RENAME...                                                         RADDAT
     D                 C                   const(2)                             x'00000002'   RADDAT
     D cIFS_MOVE_FILE_CREATE_DIRECTORY...                                                     RADDAT
     D                 C                   const(4)                             x'00000004'   RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Callback Procedures                                                                  RADDAT
     * --------------------------------                                                      RADDAT
     D ifsDirectory_read_Path...                                                              RADDAT
     D                 PR              N   extproc('ifsDirectory_read_Path')                  RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_entry                            const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUserData                    *   const                                              RADDAT
     D  o_msg                                     likeds(msg_t       )                        RADDAT
     *                                                                                       RADDAT
     D ifsDirectory_read_Dirent...                                                            RADDAT
     D                 PR              N   extproc('ifsDirectory_read_Dirent')                RADDAT
     D  i_level                      10I 0 const                                              RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_dirent                           const  likeds(dirent_t    )                        RADDAT
     D  i_type                             const  like(ifs_type_t    )                        RADDAT
     D  i_pUserData                    *   const                                              RADDAT
     D  o_msg                                     likeds(msg_t       )                        RADDAT
     *                                                                                       RADDAT
     *  Type definitions                                                                     RADDAT
     D ifs_path_t      S           5000A   varying                 based(pDummy)              RADDAT
     D ifs_hFile_t     S                   like(HANDLE_handle_t)   based(pDummy)              RADDAT
     D ifs_EOLChar_t   S             32A   varying                 based(pDummy)              RADDAT
     D ifs_type_t      S             10A                           based(pDummy)              RADDAT
     D ifs_fileID_t    S             32A                           based(pDummy)              RADDAT
     D ifs_ccsid_t     S             10U 0                         based(pDummy)              RADDAT
     *                                                                                       RADDAT
     D ifs_uniqueFileID_t...                                                                  RADDAT
     D                 DS                  qualified               based(pDummy)              RADDAT
     D  ino                          10U 0
     D  dev                          20U 0
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Imported prototypes                                                                  RADDAT
     * --------------------------------                                                      RADDAT
CPY  /COPY QIFS2,CLIB                            C Runtime Library                          RADDAT
CPY  /COPY QBASICS1,PBASICS1                     Tools/400 Runtime Library                  RADDAT
     *                                                                                       RADDAT
     * --------------------------------                                                      RADDAT
     *  Exported procedures                                                                  RADDAT
     * --------------------------------                                                      RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if the specified file exists, else cFalse.                             RADDAT
     D ifsFile_exist...                                                                       RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_exist+                                    RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Opens a given stream file.                                                           RADDAT
     D ifsFile_open...                                                                        RADDAT
     D                 PR                  like(ifs_hFile_t   )                               RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_open+                                     RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_opnFlags                    10I 0 const                                              RADDAT
     D i_codePage                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D i_pubAuth                     10I 0 const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Closes an stream file that has been opened with the ifsFile_open-function.           RADDAT
     D ifsFile_close...                                                                       RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_close+                                    RADDAT
     D                                     ')                                                 RADDAT
     D io_hFile                                   like(ifs_hFile_t   )                        RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Deletes a given stream file.                                                         RADDAT
     D ifsFile_delete...                                                                      RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_delete+                                   RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Moves a given stream file to a new location.                                         RADDAT
     D ifsFile_move...                                                                        RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_move+                                     RADDAT
     D                                     ')                                                 RADDAT
     D  i_fromPath                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_toDir                            const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Renames a given stream file.                                                         RADDAT
     D ifsFile_rename...                                                                      RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_rename+                                   RADDAT
     D                                     ')                                                 RADDAT
     D i_fromPath                          const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_toFile                            const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Copyies a given file to a directory or another file.                                 RADDAT
     D ifsFile_copy...                                                                        RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_copy+                                     RADDAT
     D                                     ')                                                 RADDAT
     D  i_fromPath                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_toPath                           const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  i_ccsid                            const  like(ifs_ccsid_t   )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Sets the read/write pointer of an open stream file to a new position.                RADDAT
     D ifsFile_seek...                                                                        RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_seek+                                     RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_offset                      10I 0 const                                              RADDAT
     D i_whence                      10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Reads data from a given stream file.                                                 RADDAT
     D ifsFile_read...                                                                        RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_read+                                     RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D o_pBuffer                       *   const                                              RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Writes data to a given stream file.                                                  RADDAT
     D ifsFile_write...                                                                       RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_write+                                    RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_pBuffer                       *   const  options(*string)                            RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Reads a line from a given stream file.                                               RADDAT
     D ifsFile_readLine...                                                                    RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_readLine+                                 RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D o_pBuffer                       *   const                                              RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D i_EOLChar                           const  like(ifs_EOLChar_t )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Writes line to a given stream file.                                                  RADDAT
     D ifsFile_writeLine...                                                                   RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_writeLine+                                RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_pBuffer                       *   const  options(*string)                            RADDAT
     D i_length                      10I 0 const                                              RADDAT
     D i_EOLChar                           const  like(ifs_EOLChar_t )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the size on a given stream file.                                             RADDAT
     D ifsFile_getSize...                                                                     RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getSize+                                  RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the size of the file referenced by a given file handle.                      RADDAT
     D ifsFile_getSizeH...                                                                    RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getSizeH+                                 RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Changes the size on a given stream file.                                             RADDAT
     D ifsFile_setSize...                                                                     RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_setSize+                                  RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Changes the size of the file referenced by a given file handle.                      RADDAT
     D ifsFile_setSizeH...                                                                    RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_setSizeH+                                 RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D i_newSize                     10I 0 const                                              RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the creation timestamp of a given stream file.                               RADDAT
     D ifsFile_getCreationTime...                                                             RADDAT
     D                 PR              Z                                                      RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getCreationTime+                          RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the timestamp the stream file data was last changed.                         RADDAT
     D ifsFile_getDataChangeTime...                                                           RADDAT
     D                 PR              Z                                                      RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getDataChangeTime+                        RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the file ID that uniquely identifies a given stream file.                    RADDAT
     D ifsFile_getUniqueID...                                                                 RADDAT
     D                 PR                         likeds(ifs_uniqueFileID_t)                  RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getUniqueID+                              RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t          )                  RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t               )                  RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the unique file ID of the file referenced by a given file handle.            RADDAT
     D ifsFile_getUniqueIDH...                                                                RADDAT
     D                 PR                         likeds(ifs_uniqueFileID_t)                  RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getUniqueIDH+                             RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t         )                  RADDAT
     D o_msg                                      like(msg_t               )                  RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the file ID as shown at the WRKLNK 'Display Attributes' screen.              RADDAT
     D ifsFile_getID...                                                                       RADDAT
     D                 PR            32A                                                      RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getID+                                    RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the file ID of the file referenced by a given file handle                    RADDAT
     *   as shown at the WRKLNK 'Display Attributes' screen.                                 RADDAT
     D ifsFile_getIDH...                                                                      RADDAT
     D                 PR            32A                                                      RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getIDH+                                   RADDAT
     D                                     ')                                                 RADDAT
     D i_hFile                             const  like(ifs_hFile_t   )                        RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Produces a unique temporary stream file name.                                        RADDAT
     D ifsFile_getTempPath...                                                                 RADDAT
     D                 PR                         like(ifs_path_t )                           RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_getTempPath+                              RADDAT
     D                                     ')                                                 RADDAT
     D o_msg                                      like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Compares the content of two files with each other.                                   RADDAT
     D ifsFile_compare...                                                                     RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsFile_compare+                                  RADDAT
     D                                     ')                                                 RADDAT
     D i_path1                             const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_path2                             const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_options                     10I 0 const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if the specified directory exists, else cFalse.                        RADDAT
     D ifsDirectory_exist...                                                                  RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_exist+                               RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Creates a new directory.                                                             RADDAT
     D ifsDirectory_create...                                                                 RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_create+                              RADDAT
     D                                     ')                                                 RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  i_auth                       10I 0 const  options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Deletes a given directory.                                                           RADDAT
     D ifsDirectory_remove...                                                                 RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_remove+                              RADDAT
     D                                     ')                                                 RADDAT
     D  i_directory                        const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Moves a given directory to a new location.                                           RADDAT
     D ifsDirectory_move...                                                                   RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsDirectory_move+                                RADDAT
     D                                     ')                                                 RADDAT
     D  i_fromPath                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_toDir                            const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_options                    10I 0 const  options(*nopass: *omit)                     RADDAT
     D  o_msg                                     like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Renames a given directory.                                                           RADDAT
     D ifsDirectory_rename...                                                                 RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R01+                                  RADDAT
     D                                     _ifsDirectory_rename+                              RADDAT
     D                                     ')                                                 RADDAT
     D i_fromDirectory...                                                                     RADDAT
     D                                     const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_toDirectory                       const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Reads the entries of a given directory.                                              RADDAT
     D ifsDirectory_read...                                                                   RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_read+                                RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_pCallback                     *   const  procptr                                     RADDAT
     D i_options                     10I 0 const  options(*nopass: *omit)                     RADDAT
     D i_pUserData                     *   const  options(*nopass: *omit)                     RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given directory is empty, else cFalse.                            RADDAT
     D ifsDirectory_isEmpty...                                                                RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_isEmpty+                             RADDAT
     D                                     ')                                                 RADDAT
     D i_dir                               const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the current working directory.                                               RADDAT
     D ifsDirectory_getCurrent...                                                             RADDAT
     D                 PR                         like(ifs_path_t    )                        RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_getCurrent+                          RADDAT
     D                                     ')                                                 RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Changes the current working directory.                                               RADDAT
     D ifsDirectory_setCurrent...                                                             RADDAT
     D                 PR            10I 0                                                    RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_setCurrent+                          RADDAT
     D                                     ')                                                 RADDAT
     D  i_dir                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Fixes the syntax of a given directory name.                                          RADDAT
     D ifsDirectory_fixSyntax...                                                              RADDAT
     D                 PR                  like(ifs_path_t    )                               RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_fixSyntax+                           RADDAT
     D                                     ')                                                 RADDAT
     D i_dir                               const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns the creation timestamp of a given directory.                                 RADDAT
     D ifsDirectory_getCreationTime...                                                        RADDAT
     D                 PR              Z                                                      RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_getCreationTime+                     RADDAT
     D                                     ')                                                 RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the timestamp the content of the directory was last changed.                 RADDAT
     D ifsDirectory_getContentChangeTime...                                                   RADDAT
     D                 PR              Z                                                      RADDAT
     D                                     extproc('IFS2R02+                                  RADDAT
     D                                     _ifsDirectory_getContentChangeTime+                RADDAT
     D                                     ')                                                 RADDAT
     D i_directory                         const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Retrieves the stream file name from a given path name.                               RADDAT
     D ifsPath_getName...                                                                     RADDAT
     D                 PR                  like(ifs_path_t    )                               RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_getName+                                  RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_isDirectory                   N   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Retrieves the directory name from a given path name.                                 RADDAT
     D ifsPath_getDirectory...                                                                RADDAT
     D                 PR                  like(ifs_path_t    )                               RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_getDirectory+                             RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_isDirectory                   N   const  options(*nopass)                            RADDAT
     *                                                                                       RADDAT
     *  Retrieves the file extension of the stream file name from a given path name.         RADDAT
     D ifsPath_getExtension...                                                                RADDAT
     D                 PR                         like(ifs_path_t    )                        RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_getExtension+                             RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Removes the extension from an stream file or path.                                   RADDAT
     D ifsPath_removeExtension...                                                             RADDAT
     D                 PR                         like(ifs_path_t    )                        RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_removeExtension+                          RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D o_msg                                      like(msg_t         )                        RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
     *  Fixes the syntax of a given path name.                                               RADDAT
     D ifsPath_fixSyntax...                                                                   RADDAT
     D                 PR                  like(ifs_path_t    )                               RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_fixSyntax+                                RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given path is a directory, else cFalse.                           RADDAT
     *  (A path is considered to be a directory if it ends with a '/'.)                      RADDAT
     D ifsPath_isDirectory...                                                                 RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_isDirectory+                              RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given path is a file, else cFalse.                                RADDAT
     *  (A path is considered to be a file if it does not end with a '/'.)                   RADDAT
     D ifsPath_isFile...                                                                      RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_isFile+                                   RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given path is an absolute path, else cFalse.                      RADDAT
     *  (A path is considered to be an absolute path if it does start with a '/'.)           RADDAT
     D ifsPath_isAbsolute...                                                                  RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_isAbsolute+                               RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given path is a relative path, else cFalse.                       RADDAT
     *  (A path is considered to be a relative path if it does not start with a '/'.)        RADDAT
     D ifsPath_isRelative...                                                                  RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_isRelative+                               RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given path does not contain a directory.                          RADDAT
     D ifsPath_isNameOnly...                                                                  RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_isNameOnly+                               RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if a given path does contain a file name pattern.                      RADDAT
     D ifsPath_isPattern...                                                                   RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R03+                                  RADDAT
     D                                     _ifsPath_isPattern+                                RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if the type of a given directory entry indicates                       RADDAT
     *  that the entry is a directory, else cFalse.                                          RADDAT
     D ifsType_isDirectory...                                                                 RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R06+                                  RADDAT
     D                                     _ifsType_isDirectory+                              RADDAT
     D                                     ')                                                 RADDAT
     D i_objType                           const  like(st_stat_t.objType)                     RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if the type of a given directory entry indicates                       RADDAT
     *  that the entry is a file, else cFalse.                                               RADDAT
     D ifsType_isFile...                                                                      RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R06+                                  RADDAT
     D                                     _ifsType_isFile+                                   RADDAT
     D                                     ')                                                 RADDAT
     D i_objType                           const  like(st_stat_t.objType)                     RADDAT
     *                                                                                       RADDAT
     *  Returns cTrue if the type of a given directory entry indicates                       RADDAT
     *  that the entry is a symbolic link, else cFalse.                                      RADDAT
     D ifsType_isSymbolicLink...                                                              RADDAT
     D                 PR              N                                                      RADDAT
     D                                     extproc('IFS2R06+                                  RADDAT
     D                                     _ifsType_isSymbolicLink+                           RADDAT
     D                                     ')                                                 RADDAT
     D i_objType                           const  like(st_stat_t.objType)                     RADDAT
     *                                                                                       RADDAT
     *  Returns the real object type of a symbolic link.                                     RADDAT
     D ifsSymLnk_getRealType...                                                               RADDAT
     D                 PR                         like(ifs_type_t  )                          RADDAT
     D                                     extproc('IFS2R07+                                  RADDAT
     D                                     _ifsSymLnk_getRealType+                            RADDAT
     D                                     ')                                                 RADDAT
     D i_path                              const  like(ifs_path_t  )                          RADDAT
     D  o_msg                                     like(msg_t      )                           RADDAT
     D                                            options(*nopass: *omit)                     RADDAT
     *                                                                                       RADDAT
 DEF  /ENDIF                                                                                  RADDAT
