% uses the old system on the poster for all of the stores

% Define constants, these are newly derived by me using the data
% and the quantity relationships, done using least squares approx
a3 = 0; b3 = 0.38053452; c3 = 0.118304303; d3 = 0.114892915;
a4 = 0; b4 = 0.213473621; c4 = 0.753812101; d4 = 0.119625997;
a5 = 0; b5 = 0.415746494; c5 = 0.156936123; d5 = 0.104806508;

% solved via the linear system provided, using adjusted values
k = 0.29217; r = 0.08619; q = 0.07923;


% Setup the matrix A symbolic components to hold the weights
A = [0 0 0 b3 0 -1 (c3+c4)/(2*b4) (c5+d3)/(2*b5) 0 0 0
     0 0 0 -c3 0 (c3+c4)/(2*b3) -1 (d4+d5)/(2*b5) 0 0 0
     0 0 0 -d3 0 -(c5+d3)/(2*b3) (d4+d5)/(2*b4) -1 0 0 0
     b3 -c3 -d3 0 0 0.5 -c5/(2*b4) -d5/(2*b5) 0 0 0
	 0 0 0 0 -c5 0 0 0 -1 (c3+c4)/(2*b4) (c5+d3)/(2*b5)
	 0 0 0 0 -d5 0 0 0 (c3+c4)/(2*b3) -1 (d4+d5)/(2*b5)
	 0 0 0 0 b5 0 0 0 (c3+d3)/(2*b3) (d4+d5)/(2*b4) -1
     -c5 -d5 b5 0 0 0 0 0 -c5/(2*b3) -d5/(2*b4) 0.5
     -1  (c3+c4)/(2*b3) (c5+d3)/(2*b3) 1/2 -c5/(2*b3) 0 0 0 0 0 0 % C1  
     (c3+c4)/(2*b4) -1 (d4+d5)/(2*b4) -c3/(2*b4) -d5/(2*b4) 0 0 0 0 0 0 % C2
     (c5+d3)/(2*b5) (d4+d5)/(2*b5) -1 -d3/(2*b5) 1/2 0 0 0 0 0 0]; % c3

b = [q*b3
     -q*c3
     -q*d3
     a3
	 -r*c5
	 -r*d3
	 r*b5	 
     a5
     (-a3/(2*b3)+(k*c4)/(2*b3))
     (-a4/(2*b4))-(k/2)  
     (-a5/(2*b5))+(d4/(2*b5))];

% Iterate over the weights to solve the system of Ax = b for each
% weight pairing
output = zeros(1, 11); % stores output values for each weight pair


% solve for x in Ax = b
output(:) = A\b;


%disp(output)

% As the model uses variables based on standardized price data
% we need to un-standardize the predicted retail prices using the mean 
% and sd of each brand. Values calculated in python.
NB_mean = 1.3551419154001096;
NB_sd  = 0.46379526916817837;
PL_mean = 0.8938039431117623; 
PL_sd = 0.4187095257909153;
CB_mean = 1.3291277543795397;
CB_sd = 0.43127096234244716;

% unadjust the predicted retail prices
u1 = (output(:,1) * NB_sd) + NB_mean;
u2 = (output(:,2) * PL_sd) + PL_mean;
u3 = (output(:,3) * CB_sd) + CB_mean;

whole_sale_prices = [u1,u2,u3];
disp(whole_sale_prices)

% TODO: figure out how to un-standardize the wholesale prices
% and be able to present those, or otherwise calculate them from the 
% given retail prices




