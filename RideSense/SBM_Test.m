function f = SBM_Test()

format long;

sMotionFeatureFileRef = 'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good\Ref_Uniqued_TmCrt_SegMF_N.csv';
sMotionFeatureFileHand = 'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good\hand_Uniqued_TmCrt_SegMF_N.csv';
sMotionFeatureFilePocket = 'E:\SensorMatching\Data\SchoolShuttle\20150929_withXiang\Red1_full_good\pantpocket_Uniqued_TmCrt_SegMF_N.csv';

mRef = load(sMotionFeatureFileRef);
mHand = load(sMotionFeatureFileHand);
mPocket = load(sMotionFeatureFilePocket);

%   fMagMeanLinearAccl,fMagStdLinearAccl,fMagRangeLinearAccl,fMagMCRLinearAccl,fMagMADLinearAccl,fMagSkewLinearAccl,fMagRMSLinearAccl,fMagSMALinearAccl, ...
%   fMagMeanGyro,fMagStdGyro,fMagRangeGyro,fMagMCRGyro,fMagMADGyro,fMagSkewGyro,fMagRMSGyro,fMagSMAGyro, ...
%   fMagMeanBaro,fMagStdBaro,fMagRangeBaro,fMagMCRBaro,fMagMADBaro,fMagSkewBaro,fMagRMSBaro,fMagSMABaro);


nIdxLinearMean = 2;
nIdxGyroMean = 10;
nIdxBaroMean = 18;

nIdxLinearStd = 3;
nIdxGyroStd = 11;
nIdxBaroStd = 19;

nIdxLinearRange = 4;
nIdxGyroRange = 12;
nIdxBaroRange = 20;


mRefStop = mRef((mRef(:,1) == 1),:);
mRefMove = mRef((mRef(:,1) == 0),:);

mHandStop = mHand((mHand(:,1) == 1),:);
mHandMove = mHand((mHand(:,1) == 0),:);

mPocketStop = mPocket((mPocket(:,1) == 1),:);
mPocketMove = mPocket((mPocket(:,1) == 0),:);


figure(1);
subplot(3,3,1);
plot(mRefStop(:,nIdxLinearMean), 'r-');
hold on;
plot(mRefMove(:,nIdxLinearMean), 'b-');

title('Mean');

subplot(3,3,2);
plot(mRefStop(:,nIdxGyroMean), 'r-');
hold on;
plot(mRefMove(:,nIdxGyroMean), 'b-');

subplot(3,3,3);
plot(mRefStop(:,nIdxBaroMean), 'r-');
hold on;
plot(mRefMove(:,nIdxBaroMean), 'b-');

%%%%%%%%%%%%%%%%

subplot(3,3,4);
plot(mHandStop(:,nIdxLinearMean), 'r-');
hold on;
plot(mHandMove(:,nIdxLinearMean), 'b-');

subplot(3,3,5);
plot(mHandStop(:,nIdxGyroMean), 'r-');
hold on;
plot(mHandMove(:,nIdxGyroMean), 'b-');

subplot(3,3,6);
plot(mHandStop(:,nIdxBaroMean), 'r-');
hold on;
plot(mHandMove(:,nIdxBaroMean), 'b-');

%%%%%%%%%%%%%%%%%

subplot(3,3,7);
plot(mPocketStop(:,nIdxLinearMean), 'r-');
hold on;
plot(mPocketMove(:,nIdxLinearMean), 'b-');

subplot(3,3,8);
plot(mPocketStop(:,nIdxGyroMean), 'r-');
hold on;
plot(mPocketMove(:,nIdxGyroMean), 'b-');

subplot(3,3,9);
plot(mPocketStop(:,nIdxBaroMean), 'r-');
hold on;
plot(mPocketMove(:,nIdxBaroMean), 'b-');



figure(2);
subplot(3,3,1);
plot(mRefStop(:,nIdxLinearStd), 'r-');
hold on;
plot(mRefMove(:,nIdxLinearStd), 'b-');

title('std');

subplot(3,3,2);
plot(mRefStop(:,nIdxGyroStd), 'r-');
hold on;
plot(mRefMove(:,nIdxGyroStd), 'b-');

subplot(3,3,3);
plot(mRefStop(:,nIdxBaroStd), 'r-');
hold on;
plot(mRefMove(:,nIdxBaroStd), 'b-');

%%%%%%%%%%%%%%%%

subplot(3,3,4);
plot(mHandStop(:,nIdxLinearStd), 'r-');
hold on;
plot(mHandMove(:,nIdxLinearStd), 'b-');

subplot(3,3,5);
plot(mHandStop(:,nIdxGyroStd), 'r-');
hold on;
plot(mHandMove(:,nIdxGyroStd), 'b-');

subplot(3,3,6);
plot(mHandStop(:,nIdxBaroStd), 'r-');
hold on;
plot(mHandMove(:,nIdxBaroStd), 'b-');

%%%%%%%%%%%%%%%%%

subplot(3,3,7);
plot(mPocketStop(:,nIdxLinearStd), 'r-');
hold on;
plot(mPocketMove(:,nIdxLinearStd), 'b-');

subplot(3,3,8);
plot(mPocketStop(:,nIdxGyroStd), 'r-');
hold on;
plot(mPocketMove(:,nIdxGyroStd), 'b-');

subplot(3,3,9);
plot(mPocketStop(:,nIdxBaroStd), 'r-');
hold on;
plot(mPocketMove(:,nIdxBaroStd), 'b-');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
subplot(3,3,1);
plot(mRef(:,nIdxLinearStd));
title('Std (stop & move)');

subplot(3,3,2);
plot(mRef(:,nIdxGyroStd));

subplot(3,3,3);
plot(mRef(:,nIdxBaroStd));

subplot(3,3,4);
plot(mHand(:,nIdxLinearStd));

subplot(3,3,5);
plot(mHand(:,nIdxGyroStd));

subplot(3,3,6);
plot(mHand(:,nIdxBaroStd));

subplot(3,3,7);
plot(mPocket(:,nIdxLinearStd));

subplot(3,3,8);
plot(mPocket(:,nIdxGyroStd));

subplot(3,3,9);
plot(mPocket(:,nIdxBaroStd));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4);
subplot(3,3,1);
plot(mRef(:,nIdxLinearRange));
title('Range (stop & move)');

subplot(3,3,2);
plot(mRef(:,nIdxGyroRange));

subplot(3,3,3);
plot(mRef(:,nIdxBaroRange));

subplot(3,3,4);
plot(mHand(:,nIdxLinearRange));

subplot(3,3,5);
plot(mHand(:,nIdxGyroRange));

subplot(3,3,6);
plot(mHand(:,nIdxBaroRange));

subplot(3,3,7);
plot(mPocket(:,nIdxLinearRange));

subplot(3,3,8);
plot(mPocket(:,nIdxGyroRange));

subplot(3,3,9);
plot(mPocket(:,nIdxBaroRange));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kk = mRef(:,nIdxLinearStd);

% alpha < 0.5
%
% If 100 Hz,  dt = 0.01s,  T = 1s,  alpha = dt/(T+dt)
%

alpha = 0.05/1.05;
%mFiltered = EMA(kk, 10);
mFiltered = LPF(kk, 1, alpha);
figure(5);
plot(mFiltered)



[nCnt ~] = size(kk);

mStdStd = [];
nStart = 1;
nEnd = nStart + 49;
nStdStdCnt = 0;

while nEnd <= nCnt
    fStdStd = std(kk(nStart:nEnd));
    nStdStdCnt = nStdStdCnt + 1;
    mStdStd(nStdStdCnt) = fStdStd;
    
    nStart = nStart + 25;
    nEnd = nStart + 49;
    
end

figure(6);
plot(mStdStd);
title('stdstd');

return;

