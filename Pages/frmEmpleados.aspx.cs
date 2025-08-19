using System;
using ProyectoGE.Models;

namespace ProyectoGE.Pages
{
    public partial class frmEmpleados : System.Web.UI.Page
    {
        private readonly EmpleadoDAL _dal = new EmpleadoDAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Cargar();  // carga al entrar
        }

        protected void btnCargar_Click(object sender, EventArgs e)
        {
            Cargar();
        }

        private void Cargar()
        {
            var resp = _dal.Listar(idDepartamento: null, buscar: null, page: 1, pageSize: 20);
            gvEmpleados.DataSource = resp.Items;
            gvEmpleados.DataBind();
            lblTotal.Text = "Total: " + resp.Total;
        }
    }
}
