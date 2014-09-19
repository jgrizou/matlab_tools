% Method for calculating precise logarithm of a sum
% The method is based on the notion that
% ln(a + b) = ln{exp[ln(a) - ln(b)] + 1} + ln(b).
%
% The method requires calling only one exp() and one log(), instead of two exp() and one log() in the basic solution. 
% Additionally, the proposed method has the critical advantage of not overflowing in case of large numbers of a and b.
%
% Usage: R = add_lns(a_ln, b_ln) 
% where
% a_ln - logarithm of first addend
% b_ln - logarithm of second addend
% R - precise logarithm of the result of the addition

function R = add_lns(a_ln, b_ln)		 % ln(a + b) = ln{exp[ln(a) - ln(b)] + 1} + ln(b) 

	if (abs(a_ln - b_ln) >= 36.043653389117155)		% 2^52-1 = 4503599627370495.	log of that is 36.043653389117155867651465390794
		R = max(a_ln, b_ln);		 % this branch is necessary, to avoid shifted_a_ln = a_ln - b_ln having too big value	
	else
		R = log(exp(a_ln - b_ln) + 1) + b_ln; 

		% shifted_a_ln = a_ln - b_ln;		
		% shifted_sum = exp(shifted_a_ln) + 1;			
		% shifted_sum_ln = log(shifted_sum);		
		% unshifted_sum_ln = shifted_sum_ln + b_ln;		
		% R = unshifted_sum_ln;    
	end

end
