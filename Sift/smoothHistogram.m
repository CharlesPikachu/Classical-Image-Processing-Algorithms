%{
Author:
    Charles
Function:
    Smooth the orientation histogram.
Input:
    -hist: orientation histogram.
    -num_iter: the number of iterate times.
Output:
    -hist: smoothed orientation histogram.
%}
function hist = smoothHistogram(hist, num_iter)
n = length(hist(1, :));
for iter = 1: num_iter
    for i = 1: n
        if i == 1
            prev = hist(n);
            next = hist(2);
        elseif i == n
            prev = hist(n-1);
            next = hist(1);
        else
            prev = hist(i-1);
            next = hist(i+1);
        end
        hist(i) = 0.25 * prev + 0.5 * hist(i) + 0.25 * next;
    end
end
end