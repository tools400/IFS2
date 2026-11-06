**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1019
//
// Fehler beim Öffnen des Verzeichnisses '&1' aufgetreten.
//
DCL-DS IFS1019;
  IFS10191 CHAR(256) INZ(*BLANKS);
  IFS10192 PACKED(010) INZ(*ZEROS);
  IFS10193 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1019_SIZE BINDEC(8) INZ(0390);
//
