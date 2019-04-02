p_start = max(1,pos_A(1)-i+1);
p_end = min(grdsz(1),pos_A(1)+i-1);
    line_d = grd_t(p_start:p_end, pos_A(2)-i+1);
    % calculate the edges
    
    lineout_sd = grd_s(p_start:p_end, pos_A(2)-i);
    lineout_d = zlc_fd_lineout(h,lineout_sd,i,line_d);
    grd_t(p_start:p_end, pos_A(2)-i) = lineout_d;