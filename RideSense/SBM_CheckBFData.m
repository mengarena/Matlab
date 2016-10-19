sRefBF = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\Feature\Ref_Uniqued_TmCrt_SegBF_1.csv';
sHandBF = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\Feature\hand_Uniqued_TmCrt_SegBF_1.csv';
sPocketBF = 'E:\SensorMatching\Data\SchoolShuttle\20150924\Evening1_full_good\Feature\pantpocket_Uniqued_TmCrt_SegBF_1.csv';

mRef = load(sRefBF);
mHand = load(sHandBF);
mPocket = load(sPocketBF);

nRefTurn = length(find(mRef(:,1)==2));
nHandTurn = length(find(mHand(:,1)==2));
nPocketTurn = length(find(mPocket(:,1)==2));
fprintf('[Turn] Ref: %d;   Hand: %d;   Pocket: %d\n', nRefTurn, nHandTurn, nPocketTurn);

mRefMove = mRef(mRef(:,1)==1,:);
mRefStop = mRef(mRef(:,1)==0,:);
fRefMove = sum(mRefMove(:,2));
fRefStop = sum(mRefStop(:,2));

mRefMove = mRef(mRef(:,1)==1,:);
mRefStop = mRef(mRef(:,1)==0,:);
fRefMove = sum(mRefMove(:,2));
fRefStop = sum(mRefStop(:,2));

fprintf('[Move/Stop Duration] Ref: [Move] %f;   [Stop]: %f\n', fRefMove, fRefStop);

mHandMove = mHand(mHand(:,1)==1,:);
mHandStop = mHand(mHand(:,1)==0,:);
fHandMove = sum(mHandMove(:,2));
fHandStop = sum(mHandStop(:,2));

mHandMove = mHand(mHand(:,1)==1,:);
mHandStop = mHand(mHand(:,1)==0,:);
fHandMove = sum(mHandMove(:,2));
fHandStop = sum(mHandStop(:,2));

fprintf('[Move/Stop Duration] Hand : [Move] %f;   [Stop]: %f\n', fHandMove, fHandStop);

mPocketMove = mPocket(mPocket(:,1)==1,:);
mPocketStop = mPocket(mPocket(:,1)==0,:);
fPocketMove = sum(mPocketMove(:,2));
fPocketStop = sum(mPocketStop(:,2));

mPocketMove = mPocket(mPocket(:,1)==1,:);
mPocketStop = mPocket(mPocket(:,1)==0,:);
fPocketMove = sum(mPocketMove(:,2));
fPocketStop = sum(mPocketStop(:,2));

fprintf('[Move/Stop Duration] Pocket: [Move] %f;   [Stop]: %f\n', fPocketMove, fPocketStop);



