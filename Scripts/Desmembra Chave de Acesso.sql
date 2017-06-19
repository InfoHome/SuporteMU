-------------------------------------------------------------------------------------------------------
--Desmembra Chave de Acesso
-------------------------------------------------------------------------------------------------------

declare @chave varchar(44)

--Informe abaixo entre aspas simples somente números da chave de acesso.
set @chave = '35170559621078001490550080000079881000019939'  

select 
	 substring(@chave,1,2)  as [Cod_UF] 			-- cUF 			
	,substring(@chave,3,4)  as [Ano_Mes] 			-- AAMM
	,substring(@chave,7,14) as [CNPJ] 				-- CNPJ
	,substring(@chave,21,2) as [Modelo] 			-- MOD
	,substring(@chave,23,3) as [Serie] 				-- Serie
	,substring(@chave,26,9) as [Numero] 			-- nnf
	,substring(@chave,35,1) as [Forma_Emissao] 		-- tpEmis
	,substring(@chave,36,8) as [Cod_Numérico] 		-- cNF
	,substring(@chave,44,1) as [Didigo_Verificador]	-- cDV
	
	


-------------------------------------------------------------------------------------------------------------------
--Calcula o Dígito Verificador da NFE
-------------------------------------------------------------------------------------------------------------------
DECLARE @i INT, @Contador INT, @Num VARCHAR(44), @Soma INT, @total NUMERIC(10, 4),@digito VARCHAR (1),@numord int

set @numord = 40		-- Informe o numord da nota

--Calulo-----------------------------------------------------------------------------------------------------------
select @Num =
	RIGHT('00' + LTRIM(RTRIM(cuf)),2) 			
	+ RIGHT('0000' + LTRIM(RTRIM(substring(convert(varchar(6),demi,112),3,4))),4)
	+ RIGHT('00000000000000' + LTRIM(RTRIM(cnpj)),14)
	+ RIGHT('00' + LTRIM(RTRIM(mod)),2)
	+ RIGHT('000' + LTRIM(RTRIM(serie)),3)
	+ RIGHT('000000000' + LTRIM(RTRIM(nnf)),9)
	+ RIGHT('0' + LTRIM(RTRIM(tpEmis)),1)
	+ RIGHT('00000000' + LTRIM(RTRIM(cNF)),8)
	-- cDV
	from Dadosnotanfe where numord = @numord

set @contador = 9
set @i = LEN(@Num)
set @soma = 0
set @total = 0.00

while @i > 0
begin
    if(@Contador >= 2)
    begin
        select @Soma = @Soma + CONVERT(INT, SUBSTRING(@num, @i, 1)) * @contador        
        set @contador = @contador -1
    end    
    else
    if(@Contador < 2)
    begin
        set @Contador = 9        
        select @Soma = @Soma + CONVERT(INT, SUBSTRING(@num, @i, 1)) * @contador    
        set @contador = @contador -1 
    end

    set @i = @i - 1    
end
SET @total = CONVERT(NUMERIC(10,4), @soma) / 11

SELECT @digito = SUBSTRING(CONVERT(VARCHAR(10), @total), CHARINDEX('.', @total) + 1, 1)

print 'Digito Verificador: ' + @digito
print 'Chave de acesso: ' + @Num + @digito
	
