**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1007
//
// Fehler beim Ändern der Größe der Datei '&1' aufgetreten.
//
DCL-DS IFS1007;
  IFS10071 CHAR(256) INZ(*BLANKS);
  IFS10072 PACKED(010) INZ(*ZEROS);
  IFS10073 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1007_SIZE BINDEC(8) INZ(0390);
//
