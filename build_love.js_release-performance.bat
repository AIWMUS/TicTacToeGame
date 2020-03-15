@echo off
echo Build love.js release-performance
cd love.js-master/release-performance
python ../emscripten/tools/file_packager.py game.data --preload ../../src@/ --js-output=game.js
