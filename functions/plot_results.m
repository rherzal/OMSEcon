function plot_results(Xstar, Zstar, Rstar, moves)
    
    time = ( 1 : moves ) .* 0.05;
    subplot(411)
    plot(time, Xstar(1, :));
    hold on;
    plot(time, zeros(1, moves));
    ylabel('\alpha [Rad]');
    subplot(412)
    plot(time, Xstar(2, :));
    ylabel('\alpha`  [Rad / s]');
    subplot(413) 
    stairs(time, Zstar);
    ylabel('u[V]');
    subplot(414)
    plot(time, Rstar)
    ylabel('r[-]')
    xlabel('t[s]')
    
end
