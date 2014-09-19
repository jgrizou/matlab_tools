% Method for calculating precise logarithm of a subtraction
% The method is based on the notion that
% ln(a - b) = ln{exp[ln(a) - ln(b)] - 1} + ln(b) IF a > b.
% It is assumed that a > b. The method does not check the validity of the inputs.
%
% The method requires calling only one exp() and one log(), instead of two exp() and one log() in the basic solution. 
% Additionally, the proposed method has the critical advantage of not overflowing in case of large numbers of a and b.
%
% Usage: R = sub_lns(a_ln, b_ln) 
% where
% a_ln - logarithm of the minuend
% b_ln - logarithm of the substrahend
% R - precise logarithm of the result of the subtraction

function R = sub_lns(a_ln, b_ln)		 % ln(a - b) = ln{exp[ln(a) - ln(b)] - 1} + ln(b) IF a > b

	if (a_ln - b_ln >= 36.043653389117155)		% 2^52-1 = 4503599627370495.	log of that is 36.043653389117155867651465390794
		R = a_ln;		 % this branch is necessary, to avoid shifted_a_ln = a_ln - b_ln having too big value	
	else
		R = log(exp(a_ln - b_ln) - 1) + b_ln; 

		% shifted_a_ln = a_ln - b_ln;		
		% shifted_diff = exp(shifted_a_ln) - 1;			
		% shifted_diff_ln = log(shifted_diff);		
		% unshifted_diff_ln = shifted_diff_ln + b_ln;		
		% R = unshifted_diff_ln;    
	end

end
