@echo off
setlocal
pushd %~dp0

set CODEGEN_TPLDIR=.\templates
set CODEGEN_OUTDIR=.\BusinessLogic
set RPSMFIL=.\rps\rpsmain.ism
set RPSTFIL=.\rps\rpstext.ism

codegen -e -s PART SUPPLIER PRODUCT_GROUP -t AsyncServicesCRUD -n BusinessLogic -r -lf

echo Code generation complete

popd
endlocal