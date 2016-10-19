function f = SS_TotalAudioResampleSplit_forGoogleSpeech()
% This function is used to group processing audio files for Google Speech Service (resample and split
% audio file, generate script for FLAC to convert from .wav to .flac) 
%
% It also generate the script for flac command in group converting .wav to
% .flac.
% And group script for Google Speech with wget under c:\sox\
%

fprintf('Start Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

sArr_AudioFiles = [ ...
    'E:\UIUC\Multimedia_Data\AM_KO\Gear_01\20140624182938.wav                                           '; ...
    'E:\UIUC\Multimedia_Data\AM_KO\Gear_02\20140714185633.wav                                           '; ...
    'E:\UIUC\Multimedia_Data\BedBathBeyond\Gear_01\20140621152728.wav                                   '; ...
    'E:\UIUC\Multimedia_Data\BestBuy\Gear_02\20140629154339.wav                                         '; ...
    'E:\UIUC\Multimedia_Data\BookStore\BarnesNoble\Gear_01\20140621151730.wav                           '; ...
    'E:\UIUC\Multimedia_Data\BookStore\FriendShopBookStore_publiclibrary\Gear_01\20140621133223.wav     '; ...
    'E:\UIUC\Multimedia_Data\BookStore\IlliniUnionBookstore\Gear_01\20140627144203.wav                  '; ...
    'E:\UIUC\Multimedia_Data\BookStore\JaneAddamsBookShop\Gear_01\20140621140234.wav                    '; ...
    'E:\UIUC\Multimedia_Data\BookStore\PricelessBooks\Gear_01\20140621143226.wav                        '; ...
    'E:\UIUC\Multimedia_Data\BookStore\TisCollege_Bookstore\Gear_02\20140627145811.wav                  '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_03\20140623192645.wav                              '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_04\20140701121328.wav                              '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_05\20140714124909.wav                              '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_06\20140716183358.wav                              '; ...
    'E:\UIUC\Multimedia_Data\CSL\Daytime\Gear_01\20140701110031.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\CSL\Daytime\Gear_02\20140701111337.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\CSL\Daytime\Gear_03\20140714140406.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\CSL\Night\Gear_01\20140624004626.wav                                       '; ...
    'E:\UIUC\Multimedia_Data\CSL\Night\Gear_02\20140715204733.wav                                       '; ...
    'E:\UIUC\Multimedia_Data\CVS\GreenStreet_S_Neil\Gear_02\20140621134248.wav                          '; ...
    'E:\UIUC\Multimedia_Data\CVS\GreenStreet_S_Neil\Gear_03\20140714183607.wav                          '; ...
    'E:\UIUC\Multimedia_Data\Hospital\Gear_01\20140712131920.wav                                        '; ...
    'E:\UIUC\Multimedia_Data\MarketPlace\Gear_01\20140629151355.wav                                     '; ...
    'E:\UIUC\Multimedia_Data\Sports\McSports\Gear_01\20140621153212.wav                                 '; ...
    'E:\UIUC\Multimedia_Data\Street\Gear_01\20140627143036.wav                                          '; ...
    'E:\UIUC\Multimedia_Data\Street\Gear_02\20140627150434.wav                                          '; ...
    'E:\UIUC\Multimedia_Data\ToysRus\Gear_01\20140621150219.wav                                         '; ...
    'E:\UIUC\Multimedia_Data\Sports\FinishLine\Gear_01\20140629152745.wav                               '; ...
    'E:\UIUC\Multimedia_Data\Walmart\Urbana\Gear_02\20140624172936.wav                                  '; ...
    'E:\UIUC\Multimedia_Data\Walmart\Urbana\Gear_03\20140710185252.wav                                  '; ...
    'E:\UIUC\Multimedia_Data\Walmart\Urbana\Gear_04\20140716204139.wav                                  '; ...
    'E:\UIUC\Multimedia_Data\Walsgreen\407E_GreenSt\Gear_02\20140627150829.wav                          '; ...
    'E:\UIUC\Multimedia_Data\Walsgreen\602W_UniversityAve\Gear_01\20140621141634.wav                    '
 ];

cellAudioFiles = cellstr(sArr_AudioFiles);

[nCnt nCol] = size(cellAudioFiles);

sFlacScriptFile = 'C:\flac\GroupFlacScript.bat';
fid_flac = fopen(sFlacScriptFile, 'w');

sWgetScriptFile = 'C:\sox\GroupWgetScript.bat';
fid_wget = fopen(sWgetScriptFile, 'w');

nStartTime = 10;
fEndPortion = 0.1;
nTargetFs = 0;
nChunkSize = 5;

for i=1:nCnt
    fprintf('Processing:  %s\n', cellAudioFiles{i});
    SS_AudioResampleSplit_forGoogleSpeech(fid_flac, fid_wget, cellAudioFiles{i}, nStartTime,  fEndPortion, nTargetFs, nChunkSize);    
end

fclose(fid_wget);
fclose(fid_flac);

fprintf('Finish Time: %s\n', datestr(clock, 'yyyy-mm-dd HH:MM:SS'));

return;
