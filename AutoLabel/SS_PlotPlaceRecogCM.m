function f = SS_PlotPlaceRecogCM()

matRecogResult = [ ...
 %%                 Walsgreen,Bestbuy,Staples,Walmart,Dollar Tree,Party city,Toysrus,Shoe Carnival,Dicks Sports,Barnes Noble, Dicks Sports
 %    Walsgreen      0.27      0.0       0.0       0.06      0.0     0.0      0.0      0.0           0.0          0.0            0.0          
 %      Bestbuy      0.15      1.0       0.0       0.12      0.15    0.08     0.07     0.0           0.0          0.15           0.0
 %      Staples      0.17      0.0       1.0       0.0       0.0     0.0      0.0      0.0           0.0          0.0            0.0
 %      Walmart      0.09      0.0       0.0       0.18      0.0     0.0      0.0      0.0           0.1          0.0            0.1
 %  Dollar Tree      0.32      0.0       0.0       0.0       0.13    0.21     0.0      0.0           0.08         0.0            0.08
 %   Party city      0.31      0.0       0.0       0.08      0.0     0.35     0.0      0.0           0.0          0.0            0.0
 %      Toysrus      0.0       0.0       0.0       0.0       0.27    0.17     0.0      0.0           0.0          0.0            0.0
 %Shoe Carnival      0.0       0.0       0.0       0.1       0.0     0.0      0.0      0.07          0.0          0.14           0.0
 % Dicks Sports      0.0       0.0       0.0       0.0       0.0     0.08     0.0      0.0           0.12         0.0            0.12
 % Barnes noble      0.14      0.0       0.0       0.0       0.0     0.07     0.0      0.0           0.0          0.0            0.0
 
 %          CVS      0.0       0.0       0.0       0.0       0.0     0.0      0.16     0.0           0.0          0.0            0.17
 %        Macys      0.13      0.0       0.0       0.14      0.14    0.0      0.0      0.0           0.0          0.0            0.1 
 %       Adidas      0.09      0.0       0.0       0.1       0.0     0.0      0.0      0.0           0.0          0.0            0.09
 %         Nike      0.0       0.0       0.0       0.0       0.0     0.0      0.0      0.0           0.0          0.06           0.06
 %        Apple      0.0       0.0       0.0       0.0       0.06    0.0      0.0      0.0           0.0          0.06           0.06
 %    Starbucks      0.0       0.0       0.0       0.0       0.05    0.0      0.0      0.0           0.0          0.05           0.0
 %       Subway      0.07      0.0       0.0       0.09      0.0     0.0      0.09     0.0           0.0          0.0            0.0
 %     Cravings      0.0       0.0       0.0       0.0       0.13    0.0      0.0      0.0           0.0          0.13           0.0
 
 
%  0.27      0.0       0.0       0.06      0.0     0.0      0.0      0.0           0.0          0.0; ...          
%  0.15      1.0       0.0       0.12      0.15    0.08     0.07     0.0           0.0          0.15; ...
%  0.17      0.0       1.0       0.0       0.0     0.0      0.0      0.0           0.0          0.0; ...
%  0.09      0.0       0.0       0.18      0.0     0.0      0.0      0.0           0.1          0.0; ...
%  0.32      0.0       0.0       0.0       0.13    0.21     0.0      0.0           0.08         0.0; ...
%  0.31      0.0       0.0       0.08      0.0     0.35     0.0      0.0           0.0          0.0; ...
%  0.0       0.0       0.0       0.0       0.27    0.17     0.0      0.0           0.0          0.0; ...
%  0.0       0.0       0.0       0.1       0.0     0.0      0.0      0.07          0.0          0.14; ...
%  0.0       0.0       0.0       0.0       0.0     0.08     0.0      0.0           0.12         0.0; ...
%  0.14      0.0       0.0       0.0       0.0     0.07     0.0      0.0           0.0          0.0;


0.27      0.0       0.0       0.06      0.0     0.0      0.0      0.0           0.0          0.0            0.0; ...         
0.15      1.0       0.0       0.12      0.15    0.08     0.07     0.0           0.0          0.15           0.0; ...
0.17      0.0       1.0       0.0       0.0     0.0      0.0      0.0           0.0          0.0            0.0; ...
0.09      0.0       0.0       0.18      0.0     0.0      0.0      0.0           0.1          0.0            0.1; ...
0.32      0.0       0.0       0.0       0.13    0.21     0.0      0.0           0.08         0.0            0.08; ...
0.31      0.0       0.0       0.08      0.0     0.35     0.0      0.0           0.0          0.0            0.0; ...
0.0       0.0       0.0       0.0       0.27    0.17     0.0      0.0           0.0          0.0            0.0; ...
0.0       0.0       0.0       0.1       0.0     0.0      0.0      0.07          0.0          0.14           0.0; ...
0.0       0.0       0.0       0.0       0.0     0.08     0.0      0.0           0.12         0.0            0.12; ...
0.14      0.0       0.0       0.0       0.0     0.07     0.0      0.0           0.0          0.0            0.0; ...
0.0       0.0       0.0       0.0       0.0     0.0      0.16     0.0           0.0          0.0            0.17; ...
0.13      0.0       0.0       0.14      0.14    0.0      0.0      0.0           0.0          0.0            0.1; ...
0.09      0.0       0.0       0.1       0.0     0.0      0.0      0.0           0.0          0.0            0.09; ...
0.0       0.0       0.0       0.0       0.0     0.0      0.0      0.0           0.0          0.06           0.06; ...
0.0       0.0       0.0       0.0       0.06    0.0      0.0      0.0           0.0          0.06           0.06; ...
0.0       0.0       0.0       0.0       0.05    0.0      0.0      0.0           0.0          0.05           0.0; ...
0.07      0.0       0.0       0.09      0.0     0.0      0.09     0.0           0.0          0.0            0.0; ...
0.0       0.0       0.0       0.0       0.13    0.0      0.0      0.0           0.0          0.13           0.0; ...

];


[nRow nCol] = size(matRecogResult);

matRecogResultNorm = [];

for i=1:nRow
    fMax = max(matRecogResult(i,:));
    mRow = [];
    
    if fMax == 0
        mRow = zeros(1, nCol);
    else
        for j=1:nCol
            mRow(j) = matRecogResult(i,j)/fMax;
        end
    end
    
    matRecogResultNorm = [matRecogResultNorm; mRow];
    
end



%xTicks = {'Walsgreen', 'Bestbuy', 'Staples', 'Walmart', 'Dollar Tree', 'Party city', 'Toysrus', 'Shoe Carnival', 'Dicks Sports', 'Barnes Noble'};
%yTicks = {'Walsgreen', 'Bestbuy', 'Staples', 'Walmart', 'Dollar Tree', 'Party city', 'Toysrus', 'Shoe Carnival', 'Dicks Sports', 'Barnes Noble'};
xTicks = {'Walsgreen', 'Bestbuy', 'Staples', 'Walmart', 'Dollar Tree', 'Party city', 'Toysrus', 'Shoe Carnival', 'Dicks Sports', 'Barnes Noble', 'Dicks Sports'};
yTicks = {'Walsgreen', 'Bestbuy', 'Staples', 'Walmart', 'Dollar Tree', 'Party city', 'Toysrus', 'Shoe Carnival', 'Dicks Sports', 'Barnes Noble', 'CVS', 'Macys', 'Adidas', 'Nike', 'Apple', 'Starbucks', 'Subway', 'Cravings'};

xLabels = 'Ground Truth Place';
yLabels = 'Predicted Place';

SS_PlotConfusion(matRecogResult, xLabels, xTicks, yLabels, yTicks, 'Place Recognition Confusion Matrix');

SS_PlotConfusion(matRecogResultNorm, xLabels, xTicks, yLabels, yTicks, 'Place Recognition Confusion Matrix (Normalized)');


return;
