
% This code is part of the supplementary material to the ICCV 2013 paper
% "Frustratingly Easy NBNN Domain Adaptation", T. Tommasi, B. Caputo. 
%
% Copyright (C) 2013, Tatiana Tommasi
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% Please cite:
% @inproceedings{TommasiICCV2013,
% author = {Tatiana Tommasi, Barbara Caputo},
% title = {Frustratingly Easy NBNN Domain Adaptation},
% booktitle = {ICCV},
% year = {2013}
% }
%
% Contact the author: ttommasi [at] esat.kuleuven.be
%

function accuracyCROSS=run_DANBNN(source, target)

% LOAD TARGET DATA
name=['data_' target '.mat'];
T=load(['./Office+Caltech/' name]); 
clear name
uy=unique(T.label);

% LOAD SOURCE DATA
name=['data_' source '.mat'];
S=load(['./Office+Caltech/' name]); 
clear name

sset=load(['./splits/' source '_select.mat']);
tset=load(['./splits/' target '_select.mat']);

  
target_ind=[];
for c=uy

    l=numel(sset.id_tr{c});
    SM.feat(1+(c-1)*l:c*l)=S.feat(sset.id_tr{c}); %SM feat is 1 x numImages cell array, each cell is featureDIM x patchNum
    SM.label(1+(c-1)*l:c*l)=S.label(sset.id_tr{c}); %label is 1 x nTrainImages

    target_ind=[target_ind tset.id_te{c}];

end
    
nte=numel(target_ind);
te=cell(nte,1);
[te{:}]=deal(T.feat{target_ind}); %te is nImagesX1 cell array. each cell array is descriptorXpatchNum
yte=T.label(target_ind); %yte is 1xtestItems

accuracyCROSS=adaptation_nomem(SM,te,yte); %yte: labels, te: cell array(one per image) for the patches, 

end