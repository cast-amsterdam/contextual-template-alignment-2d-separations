function [x_int,y_int,scores,all_tests,all_com] = MoveNode(apex_o,apex_a,node,m1,w)
%%
% This code is part of the work entitled "Contextual automated template alignment for 2D group type separations with univariate detection"
% by Nino B. L. Milani, Ferry de Kruijff, Alan R. Garcia Cicourel, Rob Edam, Tijmen S. Bos, and Bob W. J. Pirok.
%%
% apex_o: data points in the orginal data set
% apex_a: data points in the data set that requires a template (these two should be alighned)
% node: the node of the template currently being moved
% m1: normalisation values usualy the max of both dimentions
% W: weight factors
%%

% unpack input
w1 = w(1);
w2 = w(2);
w3 = w(3);
w4 = w(4);


% normalise
apex_o = apex_o ./ m1(1:2);
apex_a = apex_a ./ m1(1:2);
node = node ./ m1(1:2);

% find triangle in ref data
[idx_o,scores,v1,v2, all_tests, all_com] = WeightedTest(apex_o,node,w1,w2,w3,w4); % testing function found below.
candidate_apex_o = apex_o(idx_o,:);

% apply triangle to shifted data
loc_candidate_apex_a = zeros(size(candidate_apex_o));
for i = 1:3
    loc_candidate_apex_a(i,:) = find(and(apex_o(:,1) == candidate_apex_o(i,1), apex_o(:,2) == candidate_apex_o(i,2)));
end
x = apex_a(loc_candidate_apex_a(:,1),1);
y = apex_a(loc_candidate_apex_a(:,2),2);
A_a = apex_a(loc_candidate_apex_a(1,1),:);
B_a = apex_a(loc_candidate_apex_a(2,1),:);
C_a = apex_a(loc_candidate_apex_a(3,1),:);

u = candidate_apex_o(:,1);
v = candidate_apex_o(:,2);

p = tridef(A_a,B_a,C_a,v1,v2);
x_int = p(1);
y_int = p(2);

% Undo normalisation
apex_o = apex_o .* m1(1:2);
apex_a = apex_a .* m1(1:2);
x_int = x_int * m1(1);
y_int = y_int * m1(2);
node = node .* m1(1:2);
x = x * m1(1);
y = y * m1(2);
u = u * m1(1);
v = v * m1(2);

end


function [idx,scores,v1,v2,all_tests,all_com] = WeightedTest(apex,node,w1,w2,w3,w4)
eucli = sqrt((apex(:,1) - node(1,1)) .^2 + (apex(:,2) - node(1,2)) .^2); % calcuate euclidian distance
[euclis,loc] = sort(eucli);

search_area = round(length(euclis) .* 0.1); %reduce input to 10% of the closest datapoints
KLMmat = TripleUniqueCominations(search_area); %further reduce input only the unique combinations of 3
%prealocate space for results
vec_test = zeros(search_area,1);
box_test = zeros(search_area,1);
eqi_test = zeros(search_area,1);
asp_rat_test = zeros(search_area,1);
node_center_test = zeros(search_area,1);
ks = zeros(search_area,1);
ls = zeros(search_area,1);
ms = zeros(search_area,1);
vs = zeros(search_area,2);
% loop over al selected combinations
for i = 1:size(KLMmat,1)
    K = KLMmat(i,1);
    L = KLMmat(i,2);
    M = KLMmat(i,3);
    crnt_eucli = euclis([K,L,M]);
    node_center_test(i) = mean(crnt_eucli); %score1: mean euclidian distance

    candidate_apex = apex(loc([K,L,M]),:); %current apexes are called
    A = candidate_apex(1,:);
    B = candidate_apex(2,:);
    C = candidate_apex(3,:);

    [v1,v2] = trivec(A,B,C,node); %vector definition relative to the 3 points is calculated
    vs(i,1) = v1;
    vs(i,2) = v2;
    box_test(i) = ~and(and((v1 >= 0), (v2 >= 0)), ((v1 + v2) <= 1 )); %score2: is the node within the triangle
    ab = sqrt((candidate_apex(1,1) - candidate_apex(2,1))^2 + (candidate_apex(1,2)-candidate_apex(2,2))^2);
    bc = sqrt((candidate_apex(2,1) - candidate_apex(3,1))^2 + (candidate_apex(2,2)-candidate_apex(3,2))^2);
    ac = sqrt((candidate_apex(1,1) - candidate_apex(3,1))^2 + (candidate_apex(1,2)-candidate_apex(3,2))^2);

    eqi_test(i) = std([ab, bc, ac]); %score3: uniformatiy of the limbs
    asp_rat_test(i) = (max(candidate_apex(:,1)) - min(candidate_apex(:,1))) ./ (max(candidate_apex(:,2)) - min(candidate_apex(:,2))); %score4: aspact ratio of the triangle
    ks(i) = K;
    ls(i) = L;
    ms(i) = M;
end
%all information stored
all_com = [ks,ls,ms];
all_tests = [node_center_test,box_test,eqi_test,asp_rat_test];
%clipo all scores at 100
all_tests(isnan(all_tests)) = 100;
all_tests(all_tests > 100) = 100;
scores = (all_tests(:,1) .* w1) + (all_tests(:,2) .* w2) + (all_tests(:,3) .* w3) + (all_tests(:,4) .* w4);

[~,scr_loc] = min(scores); %find lowest score (i.e. best combination)
%return the results for those 3 apexes
scr_com = all_com(scr_loc,:);
idx = loc([scr_com(1), scr_com(2), scr_com(3)]);
v1 = vs(scr_loc,1);
v2 = vs(scr_loc,2);
end



