function label = createThLabel(value)
    if value == 1
        label = '1st';
    else
        label = [num2str(value) 'th'];
    end
end