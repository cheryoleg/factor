#include "factor.h"

void init_io(void)
{
	env.user[STDIN_ENV]  = handle(HANDLE_FD,0);
	env.user[STDOUT_ENV] = handle(HANDLE_FD,1);
	env.user[STDERR_ENV] = handle(HANDLE_FD,2);
}

void primitive_close_fd(void)
{
	HANDLE* h = untag_handle(HANDLE_FD,env.dt);
	close(h->object);
	env.dt = dpop();
}

int fill_buffer(HANDLE* h, int fd, STRING* buf)
{
	int amount = read(fd,buf + 1,buf->capacity * 2);

	h->buf_fill = (amount < 0 ? 0 : amount);
	h->buf_pos = 0;

	return amount;
}

void primitive_read_line_fd_8(void)
{
	HANDLE* h = untag_handle(HANDLE_FD,env.dt);
	int fd = h->object;

	int amount;
	int i;
	int ch;

	/* finished line, unicode */
	SBUF* line = sbuf(LINE_SIZE);

	/* read ascii from fd */
	STRING* buf;
	if(h->buffer == F)
		h->buffer = tag_object(string(BUF_SIZE,'\0'));
	buf = untag_string(h->buffer);
	
	for(;;)
	{
		if(h->buf_pos >= h->buf_fill)
		{
			amount = fill_buffer(h,fd,buf);

			if(amount < 0)
				io_error(__FUNCTION__);

			if(amount == 0)
			{
				if(line->top == 0)
				{
					/* didn't read anything before EOF */
					env.dt = F;
				}
				else
					env.dt = tag_object(line);
				return;
			}
		}

		for(i = h->buf_pos; i < h->buf_fill; i++)
		{
			ch = bget((CELL)buf + sizeof(STRING) + i);
			if(ch == '\n')
			{
				h->buf_pos = i + 1;
				env.dt = tag_object(line);
				return;
			}
			else
				set_sbuf_nth(line,line->top,ch);
		}
		
		/* We've reached the end of the above loop */
		h->buf_pos = h->buf_fill;
	}
}

void primitive_write_fd_8(void)
{
	HANDLE* h = untag_handle(HANDLE_FD,env.dt);
	int fd = h->object;
	STRING* str = untag_string(dpop());
	char* c_str = to_c_string(str);
	
	int amount = write(fd,c_str,str->capacity);
	
	if(amount < 0)
		io_error(__FUNCTION__);

	env.dt = dpop();
}

void primitive_flush_fd(void)
{
	HANDLE* h = untag_handle(HANDLE_FD,env.dt);
	int fd = h->object;

	/* if(fsync(fd) < 0)
		io_error(__FUNCTION__); */

	env.dt = dpop();
}

void primitive_shutdown_fd(void)
{
	HANDLE* h = untag_handle(HANDLE_FD,env.dt);
	int fd = h->object;

	if(shutdown(fd,SHUT_RDWR) < 0)
		io_error(__FUNCTION__);

	env.dt = dpop();
}
