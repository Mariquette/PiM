function tex_export(gca, gcf, name, size)
    set(gca,'FontSize',size,'FontWeight','bold')
    %title(name);
    set(gcf,'Units','centimeter');
    screenposition = get(gcf,'Position');
    a=5*[10 14];
	set(gcf,...
        'PaperPosition',[0 0.05 a],...
   		'PaperSize',[a]);
    %print(gcf, '-deps', name);
    %print(gcf, '-dpng','-r600',name);
    print(gcf, '-dpng',name);
end

%    		'PaperPosition',[0 0 3*screenposition(3:4)],...
%    		'PaperSize',[3*screenposition(3:4)]);