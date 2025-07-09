using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProyectoGE.Pages
{
    public partial class frmEmpleados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Opcional: código que quieras ejecutar al cargar la página
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Aquí va el código para guardar el empleado en la base de datos

            // Ejemplo simple de conexión (debes configurar tu connection string en web.config)
            string connString = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = @"INSERT INTO Empleado 
                               (Nombre, Apellido, FechaNacimiento, Telefono, Correo, Direccion, FechaIngreso, Salario, IdDepartamento, 
                                Fecha_Adicion, Adicionado_Por)
                               VALUES 
                               (@Nombre, @Apellido, @FechaNacimiento, @Telefono, @Correo, @Direccion, @FechaIngreso, @Salario, @IdDepartamento,
                                GETDATE(), @AdicionadoPor)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                cmd.Parameters.AddWithValue("@Apellido", txtApellido.Text.Trim());
                cmd.Parameters.AddWithValue("@FechaNacimiento", DateTime.Parse(txtFechaNacimiento.Text));
                cmd.Parameters.AddWithValue("@Telefono", txtTelefono.Text.Trim());
                cmd.Parameters.AddWithValue("@Correo", txtCorreo.Text.Trim());
                cmd.Parameters.AddWithValue("@Direccion", txtDireccion.Text.Trim());
                cmd.Parameters.AddWithValue("@FechaIngreso", DateTime.Parse(txtFechaIngreso.Text));
                cmd.Parameters.AddWithValue("@Salario", Decimal.Parse(txtSalario.Text));
                cmd.Parameters.AddWithValue("@IdDepartamento", int.Parse(ddlDepartamento.SelectedValue));
                cmd.Parameters.AddWithValue("@AdicionadoPor", "usuario_actual"); // Aquí pones el usuario actual

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Mostrar mensaje simple
            Response.Write("<script>alert('Empleado guardado correctamente');</script>");

            // Limpiar campos (opcional)
            txtNombre.Text = "";
            txtApellido.Text = "";
            txtFechaNacimiento.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            txtDireccion.Text = "";
            txtFechaIngreso.Text = "";
            txtSalario.Text = "";
            ddlDepartamento.SelectedIndex = 0;
        }
    }
}