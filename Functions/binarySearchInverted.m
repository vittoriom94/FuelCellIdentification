function index = binarySearchInverted(freqs,num)
left = 1;
right = length(freqs);
flag = 0;
while left <= right
    mid = ceil((left + right) / 2);
    
    if freqs(mid) == num
        index = mid;
        flag = 1;
        break;
    else if freqs(mid) < num
            right = mid - 1;
        else
            left = mid + 1;
        end
    end
end
if flag == 0
    index = mid;
end
end