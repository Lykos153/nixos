{
  booq-lib,
  lib,
}:
lib.attrsets.unionOfDisjoint (booq-lib.modulesFrom ./.) {common = ../common;}
