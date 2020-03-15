@echo off
echo Build love.js debug
cd love.js-master/debug
python ../emscripten/tools/file_packager.py game.data --preload ../../src@/ --js-output=game.js
