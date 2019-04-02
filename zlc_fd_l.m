p_start = max(1,pos_A(2)-i+1);
p_end = min(grdsz(2),pos_A(2)+i-1);
    line_l = grd_t(pos_A(1)-i+1, p_start:p_end);
    % calculate the edges
    
    lineout_sl = grd_s(pos_A(1)-i, p_start:p_end);
    lineout_l = zlc_fd_lineout(h,lineout_sl,i,line_l);
    grd_t(pos_A(1)-i, p_start:p_end) = lineout_l;
    