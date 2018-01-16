USE [WebBI]
GO

/****** Object:  StoredProcedure [dbo].[SP_MUBI_CROSSTABS_ORGRESULT2]    Script Date: 10/01/2018 09:27:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[SP_MUBI_CROSSTABS_ORGRESULT2] 
                @query varchar(8000)
as
begin
	  execute (@query)
end



GO


