% new version of the problem based on gradients of the new weighted
% system 
% coeffecients derived using only the stores marked as medium

% Define constants, these are newly derived by me using the data
% and the quantity relationships, done using least squares approx
a3 = 0; b3 = 0.41232866; c3 = 0.15287876; d3 = 0.17703117;
a4 = 0; b4 = 0.24603827; c4 = 0.0953165; d4 = 0.15971384;
a5 = 0; b5 = 0.42312063; c5 = 0.20378519; d5 = 0.14132281;

% solved via the linear system provided, using adjusted values
k = 0.29217; r = 0.08619; q = 0.07923;

n = 25; % number of pareto points
weight_min = 0; weight_max = 1;
weight_array = weight_min:(weight_max-weight_min)/(n-1):weight_max; % produces n evenly spaced points from weight_min to max

% symbolic weight variables for A and b, used to keep having to
% reinstantiate A and b each loop
syms w1 w2 

% Setup the matrix A symbolic components to hold the weights
A = [0 0 0 -1*w1*b3 w2*c5 1 -1*(c3+c4)/(2*b4) -1*(c5+d3)/(2*b5)
     0 0 0 w1*c3 w2*d5 -1*(c3+c4)/(2*b3) 1 -1*(d4+d5)/(2*b5)
     0 0 0 w1*d3 -1*w2*b5 -1*(c5+d3)/(2*b3) -1*(d4+d5)/(2*b4) 1
     -1*w1*b3 w1*c3 w1*d3 0 0 -0.5 c5/(2*b4) -d5/(2*b5)
     w2*c5 w2*d5 -1*w2*b5 0 0 -c5/(2*b3) d5/(2*b4) -0.5
     -1  (c3+c4)/(2*b3) (c5+d3)/(2*b3) 1/2 -c5/(2*b3) 0 0 0 % C1  
      (c3+c4)/(2*b4) -1 (d4+d5)/(2*b4) -c3/(2*b4) -d5/(2*b4) 0 0 0 % C2
      (c5+d3)/(2*b5) (d4+d5)/(2*b5) -1 -d3/(2*b5) 1/2 0 0 0]; % c3

b = [-1*w1*q*b3 + w2*c5*r
     w1*q*c3 + w2*r*d5
     w1*q*d3 - w2*r*b5
     -1*w1*a3
     -1*w2*a5
     (-a3/(2*b3)+(k*c4)/(2*b3))
     (-a4/(2*b4))-(k/2)  
     (-a5/(2*b5))+(d4/(2*b5))];

% Iterate over the weights to solve the system of Ax = b for each
% weight pairing
output = zeros(n, 8); % stores output values for each weight pair
for i=1:n
    % get the current weight
    current_weight = weight_array(i);
    current_w1 = current_weight;
    current_w2 = 1 - current_weight;

    % substitute the symbolic w1 and w2 for their current values
    % and A and b
    current_A = subs(A, {w1, w2}, {current_w1, current_w2});
    current_b = subs(b, {w1, w2}, {current_w1, current_w2});

    % solve for x in Ax = b
    output(i,:) = current_A\current_b;
end

%disp(output)

% As the model uses variables based on standardized price data
% we need to un-standardize the predicted retail prices using the mean 
% and sd of each brand. Values calculated in python.
NB_mean =  1.3277820940819423 ; NB_sd =  0.4736787331075212 ;
PL_mean =  0.8623320182094083 ; PL_sd =  0.40756610596942067 ;
CB_mean =  1.3043793626707132 ; CB_sd =  0.44938183330909504 ;

% unadjust the predicted retail prices
u1 = (output(:,1) * NB_sd) + NB_mean;
u2 = (output(:,2) * PL_sd) + PL_mean;
u3 = (output(:,3) * CB_sd) + CB_mean;

avg_whole_sale_prices = [mean(u1,'all'),mean(u2,'all'),mean(u3,'all')];
disp(avg_whole_sale_prices)

p = plot(weight_array,u1,weight_array,u2,weight_array,u3);
p(1).Marker = "o"; p(1).Color = "blue";
p(2).Marker = "+"; p(2).Color = "green";
p(3).Marker = "^"; p(3).Color = "red";
title("Predicted Retail Prices of Medium Stores")
xlabel("Value of Gamma 1")
ylabel("Predicted Retail Prices")
legend({"National Brand", "Private Label","Competiting Brand"},"location","best")
fontsize(16,"points")

% TODO: figure out how to un-standardize the wholesale prices
% and be able to present those, or otherwise calculate them from the 
% given retail prices




