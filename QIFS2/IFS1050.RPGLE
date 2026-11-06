**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1050
//
// Fehler beim Abrufen der Attribute des symbolischen Links '&
//
DCL-DS IFS1050;
  IFS10501 CHAR(256) INZ(*BLANKS);
  IFS10502 PACKED(010) INZ(*ZEROS);
  IFS10503 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1050_SIZE BINDEC(8) INZ(0390);
//
