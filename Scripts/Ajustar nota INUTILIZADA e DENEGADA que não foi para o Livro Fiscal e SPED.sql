------------------------------------------------------------------------------------------------------------------------------------------
-- Ajustar nota INUTILIZADA e DENEGADA que não foi para o Livro Fiscal e SPED.sql
-- Vejas os comentários do código para ajudar
------------------------------------------------------------------------------------------------------------------------------------------
select 
	n.valcontab NF_valcontab, N.ModeloNf, N.Tpo NF_Tpo, N.NumOrd NF_NumOrd, 
	N.NumNota NF_NumNota, N.EspDoc NF_EspDoc, N.Serie NF_Serie, N.DtEmis NF_DtEmis, 
	N.CodClie NF_CodClie, N.FilTransf NF_FilTransf, N.Estado NF_Estado, N.IcmsIPI NF_IcmsIPI, 
	case 
		when C.ValSubstri > 0 then O.Observacao 
		when O.Observacao like '%substituicao%' 
		then '' 
		else O.Observacao 
		end OBS_Observacao, 
	case 
		when O.Observacao like 'Tributacao feita pelo Cupom Fiscal%' 
		then 'NF-e No ' + replicate('0', 9 - len(ltrim(rtrim(N.NumNota)))) + ltrim(rtrim(N.NumNota)) + ', de ' + CONVERT(CHAR(10), N.DtEmis, 103) 
		else '' 
		end OBS_observNFCF, 
	case 
		when C.ValSubstri > 0 then O.Tipo 
		when O.Observacao like '%substituicao%' then '' 
		else O.Tipo 
		end OBS_Tipo, 
		C.*, N.DtCancel NF_DtCancel, isnull(CP.SituacaoNfe,'') NF_SituacaoNfe, 
		N.Fat NF_Fat, N.FlagEmit NF_FlagEmit, N.Filial, N.nOrdVen, N.NumNfEcf, N.NumEcf, F.Oid OidFilial, T.Oid OidTpo, 
		0 DestacaImpostosNFCF, cast('' as char(4)) CfopNFCF 
from NfSaidaCad N 
	left join ObservaLif O on (N.NumOrd = O.NumOrd and (O.CFO = ' ' or O.CFO is null)) 
	join CfoSaidCad C on (N.NumOrd = C.NumOrd) 
	left join ComplementoNfSaida CP on (CP.NumOrd = N.NumOrd) 
	join FilialCad F on (N.Filial = F.Filial) 
	join Tpo T on (N.Tpo = T.HierarquiaNumero) 	-- Tem que ter um TPO na NfSaidaCad
where N.Filial = '01' 
	and N.Lif = 1 -- Tem está integrada no Livro Fiscal
	and ((N.Atualiz = 1 and N.DtCancel is null) -- Quando a nota não for Inutilizada, Denegada e Cancelada
			or (N.Atualiz = 0 and N.DtCancel is null and CP.SituacaoNfe = 'T') -- ou Quando a nota for INUTILIZADA
			or (N.DtCancel is not null and CP.SituacaoNfe = 'D')) -- ou Quando a nota for DENEGADA
	and n.dtemis >= '20161020' and n.dtemis <= '20161020' 
	--and n.numord in (Insira um numord para debugar uma nota específica)
order by N.DtEmis, N.NumNota 

--------------------------------------------------------------------------------
-- Ajuste:
-----------------------------
UPDATE NFSAIDACAD SET lif = 1, CFO = 'Informs o CFOP', tpo = 'Informe o TPO do Cliente' WHERE numord in (/*informe o(s) numord*/)
UPDATE CFOSAIDCAD SET CFO = 'Informs o CFOP' WHERE numord in (/*informe o(s) numord*/)



