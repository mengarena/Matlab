function f = SS_Plot_Frame_Feature_Total()
% This function is used to plot the distribution of frame Energy or ZCR for
% the listed audio feature vector files
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sFeatureFiles = [ ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_03\20140623192645_Feature_Train.csv             '; ...
    'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_04\20140701121328_Feature_Train.csv             '
];

sStores = [ ...
    'Cravings Restaurant Day 1                         '; ...
    'Cravings Restaurant Day 2                         '
];

% sFeatureFiles = [ ...
%     'E:\UIUC\Multimedia_Data\BookStore\BarnesNoble\Gear\20140621151730_Feature_Train.csv             '; ...
%     'E:\UIUC\Multimedia_Data\Walsgreen\407E_GreenSt\Gear_02\20140627150829_Feature_Train.csv         '; ...
%     'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_03\20140623192645_Feature_Train.csv             '; ...
%     'E:\UIUC\Multimedia_Data\Street\Gear_02\20140627150434_Feature_Train.csv                         '
% ];
% 
% sStores = [ ...
%     'Barnes Noble                                '; ...
%     'Walsgreen                                   '; ...
%     'Craving Restaurant                          '; ...
%     'Street                                      '
% ];

%%% All bookstores
% sFeatureFiles = [ ...
%     'E:\UIUC\Multimedia_Data\BookStore\BarnesNoble\Gear\20140621151730_Feature_Train.csv                               '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\FriendShopBookStore_publiclibrary\Gear\20140621133223_Feature_Train.csv         '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\IlliniUnionBookstore\Gear_01\20140627144203_Feature_Train.csv                   '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\JaneAddamsBookShop\Gear\20140621140234_Feature_Train.csv                        '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\PricelessBooks\Gear\20140621143226_Feature_Train.csv                            '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\TisCollege_Bookstore\Gear_02\20140627145811_Feature_Train.csv                   '
% ];
% 
% sStores = [ ...
%     'Barnes Noble                                '; ...
%     'FriendShop Bookstore                        '; ...
%     'Illini Union Bookstore                      '; ...
%     'Jane Addams Bookshop                        '; ...
%     'Preceless Bookstore                         '; ...
%     'T.I.S College Bookstore                     '
% ];

% All together
% sFeatureFiles = [ ...
%     'E:\UIUC\Multimedia_Data\BookStore\BarnesNoble\Gear\20140621151730_Feature_Train.csv                               '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\FriendShopBookStore_publiclibrary\Gear\20140621133223_Feature_Train.csv         '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\IlliniUnionBookstore\Gear_01\20140627144203_Feature_Train.csv                   '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\JaneAddamsBookShop\Gear\20140621140234_Feature_Train.csv                        '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\PricelessBooks\Gear\20140621143226_Feature_Train.csv                            '; ...
%     'E:\UIUC\Multimedia_Data\BookStore\TisCollege_Bookstore\Gear_02\20140627145811_Feature_Train.csv                   '; ...
%     'E:\UIUC\Multimedia_Data\Walsgreen\407E_GreenSt\Gear_02\20140627150829_Feature_Train.csv                           '; ...
%     'E:\UIUC\Multimedia_Data\Walsgreen\602W_UniversityAve\Gear\20140621141634_Feature_Train.csv                        '; ...
%     'E:\UIUC\Multimedia_Data\CVS\GreenStreet_S_Neil\Gear_02\20140621134248_Feature_Train.csv                           '; ...
%     'E:\UIUC\Multimedia_Data\CravingsRestaurant\Gear_03\20140623192645_Feature_Train.csv                               '; ...
%     'E:\UIUC\Multimedia_Data\CSL\Daytime\Gear_02\20140701111337_Feature_Train.csv                                      '; ...
%     'E:\UIUC\Multimedia_Data\Street\Gear_02\20140627150434_Feature_Train.csv                                           '
% ];
% 
% sStores = [ ...
%     'Barnes Noble                                '; ...
%     'FriendShop Bookstore                        '; ...
%     'Illini Union Bookstore                      '; ...
%     'Jane Addams Bookshop                        '; ...
%     'Preceless Bookstore                         '; ...
%     'T.I.S College Bookstore                     '; ...
%     'Walsgreen A                                 '; ...
%     'Walsgreen B                                 '; ...
%     'CVS                                         '; ...
%     'Craving Restaurant                          '; ...
%     'CSL                                         '; ...
%     'Street                                      '
% ];


SS_Plot_FrameEnergy(sFeatureFiles, sStores, 1);

SS_Plot_FrameZcr(sFeatureFiles, sStores, 2);

return;

