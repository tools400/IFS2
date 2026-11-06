**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1025
//
// Fehler beim Abrufen der Objektberechtigungen für die Datei
//
DCL-DS IFS1025;
  IFS10251 CHAR(256) INZ(*BLANKS);
  IFS10252 PACKED(010) INZ(*ZEROS);
  IFS10253 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1025_SIZE BINDEC(8) INZ(0390);
//
