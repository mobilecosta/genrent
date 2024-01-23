#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCadZA1 º Autor ³ Juliano Junio       º Data ³  26/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro Fabricantes                  .                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Century.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fCadZA1()
Private cString   := "ZA1"
Private cEmpresa  := Upper(SubStr(Alltrim(SM0->M0_NOME),1,1)) + Lower(SubStr(Alltrim(SM0->M0_NOME),2,Len(Alltrim(SM0->M0_NOME)))) + " / " + Upper(SubStr(Alltrim(SM0->M0_FILIAL),1,1)) + Lower(SubStr(Alltrim(SM0->M0_FILIAL),2,Len(Alltrim(SM0->M0_FILIAL))))
Private oBrowse
Private cRotina   := "Fabricantes " + cEmpresa +")"
Private aRotina   := MenuDef()
Private cCadastro := cRotina

// - Monta Objeto MVC Browser.
oBrowse:= FWmBrowse():New()
oBrowse:SetDescription(cRotina)
oBrowse:SetWalkThru(.F.)
oBrowse:SetAlias(cString)
oBrowse:DisableDetails()

/*/ {Protheus.doc} Function
Gravação do modelo da atualização A5_FABR com Z1_DESC, pelo campo A5_XFABR

@author 
@version P12
@since 23/01/2024
@return oModel
/*/
//-----------------------------------------------------------------------------
Class AtualizarA5Model
   Data A5_XFABR, A5_FABR, ZA1_DESC, ZA1_COD,cSQL

   Method AtualizarA5_FABR(cA5_XFABR)
   Local cSQL := ""
 
      // Construa a instrução SQL para atualizar A5_FABR com ZA1_DESC
      cSQL := "UPDATE " + RetSqlName("SA5") + ;
              " SET A5_FABR = ZA1_DESC" + ;
              " WHERE A5_XFABR = '" + cA5_XFABR + "'"

      // Início da transação
      BeginTrans()

      // Execução da atualização
      If (TCSQLExec(cSQL) <> 0)
         // Se houver um erro, emita uma mensagem de erro
         Help(,, "SeuModel:AtualizarA5_FABR",, "Erro ao atualizar A5_FABR", 1, 0)
         // Desfaça a transação
         Rollback()
         Return .F.
      EndIf

      // Fim da transação
      Commit()
      Return .T.
   EndMethod

   Method AtualizarA5_XFABR(cA5_FABR, cZA1_DESC, cZA1_COD)
      Local cSQL := ""

      // Construa a instrução SQL para atualizar A5_XFABR
      cSQL := "UPDATE " + RetSqlName("ZA1") + ;
              " SET A5_XFABR = 'ZA1_DESC'" + ;
              " WHERE A5_FABR = '" + cA5_FABR + "' AND ZA1_DESC = '" + cZA1_DESC + "' AND ZA1_COD = '" + cZA1_COD + "'"

      // Início da transação
      BeginTrans()

      // Execução da atualização
      If (TCSQLExec(cSQL) <> 0)
         // Se houver um erro, emita uma mensagem de erro
         Help(,, "SeuModel:AtualizarA5_XFABR",, "Erro ao atualizar A5_XFABR", 1, 0)
         // Desfaça a transação
         Rollback()
         Return .F.
      EndIf

      // Fim da transação
      Commit()
      Return .T.
   EndMethod
EndClass




// - Ativa o Objeto Browser para sua exibicao.
oBrowse:Activate()
Return
***********************
// Monta Painel de Controle do Browser Principal.
Static Function MenuDef()
Local aRotina   := {}

// - Adciona itens ao Array aRotina.
ADD OPTION aRotina Title 'Incluir' Action "AxInclui" OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action "AxAltera" OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action "AxDeleta" OPERATION 5 ACCESS 0
Return aRotina
**************************************************************************************************************************************************************************
Class AtualizarA5Controller
   Method AtualizarCampos(cA5_XFABR, cA5_FABR, cZ1_DESC, cZ1_COD)
      Local oModel := AtualizarA5Model():New()

      // Chamada para atualizar A5_FABR com Z1_DESC
      If !oModel:AtualizarA5_FABR(cA5_XFABR)
         // Tratar erro, se necessário
         Return
      EndIf

      // Chamada para atualizar A5_XFABR com base em A5_FABR, Z1_DESC e Z1_COD
      If !oModel:AtualizarA5_XFABR(cA5_FABR, cZ1_DESC, cZ1_COD)
         // Tratar erro, se necessário
         Return
      EndIf
   EndMethod
EndClass

